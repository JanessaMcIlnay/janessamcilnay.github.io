
library(tidyverse)
library(readxl)
library(dplyr)
library(tidyr)


raw_data <- read_excel('media/XLS_FGM-Women-prevalence-database_Mar-2024.xlsx', 
                       sheet = "Women FGM", skip = 6)

# Drop the first few rows that contain non-data info
clean_data <- raw_data[-c(1:3), ]


# Rename the columns manually
colnames(clean_data) <- c(
  "Country", "Prevalence_Total", "NA1",
  "Residence_Urban", "NA2", "Residence_Rural",
  "NA3", "Wealth_Poorest", "NA4",
  "Wealth_Second", "NA5", "Wealth_Middle", "NA6",
  "Wealth_Fourth", "NA7", "Wealth_Richest", "NA8", "Year", "Source"
)

# Drop unused "NA*" columns
clean_data <- clean_data %>%
  select(-starts_with("NA")) 


# Remove rows with all NAs
clean_data <- clean_data %>% filter(!if_all(everything(), is.na))

# Convert relevant columns to numeric (ignore warnings for "-")
clean_data2 <- clean_data %>%
  mutate(across(where(is.character), ~na_if(.x, "-"))) %>%
  mutate(across(c(Prevalence_Total, Residence_Urban, Residence_Rural,
                  Wealth_Poorest, Wealth_Second, Wealth_Middle,
                  Wealth_Fourth, Wealth_Richest), as.numeric))


FGM <- clean_data %>%
  filter(!if_all(c(Prevalence_Total, Residence_Urban, Residence_Rural,
                   Wealth_Poorest, Wealth_Second, Wealth_Middle,
                   Wealth_Fourth, Wealth_Richest), is.na)) 

