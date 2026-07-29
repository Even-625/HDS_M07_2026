# 02_functions.R

# Purpose:
# Define reusable helper functions for variable dictionaries, value labels,
# keyword searches, and spreadsheet export.

# Inputs:
# None directly. The functions use objects passed as function arguments.

# Outputs:
# Function definitions only.

# Notes:
# This script should be sourced only by scripts that need these helper
# functions. It does not read raw data or write outputs by itself.


# ------------------------------------------------------------
# 1. Read one variable dictionary
# ------------------------------------------------------------

read_one_dictionary <- function(table_name, file_name, wave11_path) {
  
  path <- file.path(wave11_path, file_name)
  
  sheet_to_read <- if ("Variable" %in% readxl::excel_sheets(path)) {
    "Variable"
  } else {
    2
  }
  
  raw <- readxl::read_excel(path, sheet = sheet_to_read)
  
  names(raw) <- stringr::str_squish(names(raw))
  
  if ("Variable Name" %in% names(raw)) {
    var_col <- "Variable Name"
    label_col <- "Variable Label"
  } else if ("variable_name" %in% names(raw)) {
    var_col <- "variable_name"
    label_col <- "variable_label"
  } else {
    stop(paste("Cannot find variable name columns in:", file_name))
  }
  
  tibble::tibble(
    table = table_name,
    variable = stringr::str_trim(as.character(raw[[var_col]])),
    variable_key = stringr::str_to_lower(
      stringr::str_trim(as.character(raw[[var_col]]))
    ),
    label_from_dictionary = stringr::str_squish(as.character(raw[[label_col]]))
  ) %>%
    dplyr::filter(!is.na(variable), variable != "")
}


# ------------------------------------------------------------
# 2. Make variable list from one dataset
# ------------------------------------------------------------

make_varlist <- function(df, table_name) {
  
  data.frame(
    table = table_name,
    variable = names(df),
    variable_key = stringr::str_to_lower(stringr::str_trim(names(df))),
    type = sapply(df, function(x) class(x)[1]),
    n_missing = sapply(df, function(x) sum(is.na(x))),
    stringsAsFactors = FALSE
  )
}


# ------------------------------------------------------------
# 3. Build labelled variable list for all Wave 11 tables
# ------------------------------------------------------------

build_variable_dictionary <- function(w11_datasets, dict_files, wave11_path) {
  
  dict_w11_all <- dplyr::bind_rows(
    lapply(seq_len(nrow(dict_files)), function(i) {
      read_one_dictionary(
        table_name = dict_files$table[i],
        file_name = dict_files$file_name[i],
        wave11_path = wave11_path
      )
    })
  ) %>%
    dplyr::distinct(table, variable_key, .keep_all = TRUE)
  
  var_w11_all <- lapply(names(w11_datasets), function(name) {
    make_varlist(w11_datasets[[name]], name)
  }) %>%
    dplyr::bind_rows()
  
  var_w11_all_labeled <- var_w11_all %>%
    dplyr::left_join(
      dict_w11_all %>%
        dplyr::select(table, variable_key, label_from_dictionary),
      by = c("table", "variable_key")
    ) %>%
    dplyr::mutate(
      label = label_from_dictionary
    ) %>%
    dplyr::select(table, variable, label, type, n_missing)
  
  return(var_w11_all_labeled)
}


# ------------------------------------------------------------
# 4. Search variables by keywords
# ------------------------------------------------------------

search_vars <- function(keywords, var_dict, table_name = NULL) {
  
  pattern <- paste(keywords, collapse = "|")
  
  result <- var_dict %>%
    dplyr::filter(
      stringr::str_detect(
        variable,
        stringr::regex(pattern, ignore_case = TRUE)
      ) |
        stringr::str_detect(
          dplyr::coalesce(label, ""),
          stringr::regex(pattern, ignore_case = TRUE)
        )
    )
  
  if (!is.null(table_name)) {
    result <- result %>%
      dplyr::filter(table == table_name)
  }
  
  result %>%
    dplyr::arrange(table, variable)
}


# ------------------------------------------------------------
# 5. Read one value label dictionary
# ------------------------------------------------------------

read_one_value_dictionary <- function(table_name, file_name, wave11_path) {
  
  path <- file.path(wave11_path, file_name)
  sheets <- readxl::excel_sheets(path)
  
  if (length(sheets) < 3) {
    stop(paste("This dictionary has fewer than 3 sheets:", file_name))
  }
  
  message(
    "Reading value dictionary: ",
    table_name,
    " | ",
    file_name,
    " | sheet = ",
    sheets[3]
  )
  
  raw <- readxl::read_excel(
    path,
    sheet = 3,
    col_types = "text"
  )
  
  names(raw) <- names(raw) %>%
    stringr::str_squish() %>%
    stringr::str_to_lower()
  
  find_col <- function(possible_names, file_name) {
    
    matched <- possible_names[possible_names %in% names(raw)]
    
    if (length(matched) == 0) {
      stop(
        paste0(
          "Cannot find columns: ",
          paste(possible_names, collapse = " / "),
          " in: ",
          file_name,
          "\nAvailable columns are: ",
          paste(names(raw), collapse = ", ")
        )
      )
    }
    
    matched[1]
  }
  
  var_col <- find_col(
    c("variable name", "variable_name", "varname"),
    file_name
  )
  
  code_col <- find_col(
    c("value code", "value_code", "code"),
    file_name
  )
  
  label_col <- find_col(
    c("value label", "value_label", "code_label", "code label"),
    file_name
  )
  
  tibble::tibble(
    source_table = table_name,
    variable_name = stringr::str_trim(as.character(raw[[var_col]])),
    variable_key = stringr::str_to_lower(
      stringr::str_trim(as.character(raw[[var_col]]))
    ),
    value_code = stringr::str_trim(as.character(raw[[code_col]])),
    value_label = stringr::str_squish(as.character(raw[[label_col]]))
  ) %>%
    dplyr::filter(
      !is.na(variable_name),
      variable_name != "",
      !is.na(value_code),
      value_code != "",
      !is.na(value_label),
      value_label != ""
    ) %>%
    dplyr::mutate(
      code_and_meaning = paste(value_code, value_label)
    ) %>%
    dplyr::distinct(
      source_table,
      variable_name,
      variable_key,
      value_code,
      value_label,
      code_and_meaning,
      .keep_all = TRUE
    )
}


# ------------------------------------------------------------
# 6. Build value dictionary for all Wave 11 dictionary files
# ------------------------------------------------------------

build_value_dictionary <- function(dict_files, wave11_path) {
  
  value_dict_w11_all <- purrr::map2_dfr(
    dict_files$table,
    dict_files$file_name,
    ~ read_one_value_dictionary(
      table_name = .x,
      file_name = .y,
      wave11_path = wave11_path
    )
  )
  
  return(value_dict_w11_all)
}


# ------------------------------------------------------------
# 7. Search value codes
# ------------------------------------------------------------

search_code <- function(var_names, value_dict, table_name = NULL) {
  
  var_keys <- stringr::str_to_lower(stringr::str_trim(var_names))
  
  result <- value_dict %>%
    dplyr::filter(variable_key %in% var_keys)
  
  if (!is.null(table_name)) {
    result <- result %>%
      dplyr::filter(source_table == table_name)
  }
  
  result <- result %>%
    dplyr::select(
      source_table,
      variable_name,
      code_and_meaning
    ) %>%
    dplyr::distinct() %>%
    dplyr::arrange(source_table, variable_name, code_and_meaning)
  
  if (nrow(result) == 0) {
    message("No value codes found for these variables.")
  }
  
  return(result)
}


# ------------------------------------------------------------
# 8. Export search results safely
# ------------------------------------------------------------

export_xlsx <- function(data, file_name, output_path) {
  
  dir.create(output_path, recursive = TRUE, showWarnings = FALSE)
  
  writexl::write_xlsx(
    data,
    file.path(output_path, file_name)
  )
}
