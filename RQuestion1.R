# Import required libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyr)
library(scales)

# Load the specified sheet from the Excel file, skipping the initial 8 rows
fraud_dataset <- read_excel("D:/Code/HF/24-11-2024/cw_r.xlsx", sheet = "Table 3d", skip = 8)

# Examine the structure of the loaded data for understanding its format
str(fraud_dataset)

# Update column names for better readability and usage
colnames(fraud_dataset) <- c("Fraud_Type", "Year_2012_2013", "Year_2013_2014", "Year_2014_2015", "Year_2015_2016",
                             "Year_2016_2017", "Year_2017_2018", "Year_2018_2019", "Year_2019_2020", "Year_2020_2021", 
                             "Year_2021_2022", "Percent_Change")

# Create subsets of data for different types of fraud
# Extract data related to fraud in the banking and credit industry
banking_fraud_data <- fraud_dataset %>%
  filter(Fraud_Type == "Banking and credit industry fraud") %>%
  select(-Fraud_Type, -Percent_Change) %>%
  pivot_longer(cols = starts_with("Year"), names_to = "Year", values_to = "Fraud_Count")

# Extract data related to fraud in charities
charity_fraud_data <- fraud_dataset %>%
  filter(Fraud_Type == "All charity fraud") %>%
  select(-Fraud_Type, -Percent_Change) %>%
  pivot_longer(cols = starts_with("Year"), names_to = "Year", values_to = "Fraud_Count")

# Check the structure of the subsets for accuracy
str(banking_fraud_data)
str(charity_fraud_data)

# Preview the first few entries in each subset
head(banking_fraud_data)
head(charity_fraud_data)

# Arrange data by year to ensure proper order for visualization
banking_fraud_data <- banking_fraud_data[order(banking_fraud_data$Year), ]
charity_fraud_data <- charity_fraud_data[order(charity_fraud_data$Year), ]

# Visualize yearly counts of charity fraud using a bar chart with theme_bw
ggplot(charity_fraud_data, aes(x = Year, y = Fraud_Count, fill = Year)) +
  geom_bar(stat = "identity") +
  labs(title = "Yearly Charity Fraud Counts",
       x = "Year",
       y = "Number of Cases") +
  scale_y_continuous(labels = comma) +
  theme_bw()

# Visualize yearly counts of banking fraud using a bar chart with theme_bw
ggplot(banking_fraud_data, aes(x = Year, y = Fraud_Count, fill = Year)) +
  geom_bar(stat = "identity") +
  labs(title = "Yearly Banking Fraud Counts",
       x = "Year",
       y = "Number of Cases") +
  scale_y_continuous(labels = comma) +
  theme_bw()
