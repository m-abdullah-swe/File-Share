# Import necessary libraries
library(readxl)
library(ggplot2)
library(dplyr)
library(tidyr)


# Load the dataset from the "Table 5" sheet, skipping the first 9 rows
crime_records <- read_excel("D:/Code/HF/24-11-2024/cw_r.xlsx", sheet = "Table 5", skip = 9)

# Examine the structure of the dataset to understand the column names and types and rename the columns
str(crime_records)
colnames(crime_records) <- c("Region_Code", "Region_Name", "Offence_Count", "Rate_Per_1000", "Change_Percentage")


# Convert the "Rate_Per_1000" column to numeric to enable proper calculations
crime_records$Rate_Per_1000 <- as.numeric(crime_records$Rate_Per_1000)

# Filter out rows where "Offence_Count" or "Rate_Per_1000" have missing values
crime_records <- crime_records %>%
  filter(!is.na(Offence_Count) & !is.na(Rate_Per_1000))

# Aggregate the data by region to calculate total offences and average rate per 1000 population
regional_summary <- crime_records %>% 
  group_by(Region_Name) %>%
  summarize(
    total_offences = sum(Offence_Count, na.rm = TRUE),
    avg_rate_per_1000 = mean(Rate_Per_1000, na.rm = TRUE)
  )

# Display the aggregated regional data for verification
print(regional_summary)

# Create a lollipop plot showing total offences by region, using a classic theme
ggplot(regional_summary, aes(x = reorder(Region_Name, total_offences), y = total_offences)) +
  geom_segment(aes(xend = Region_Name, yend = 0), color = "black") +
  geom_point(color = "orange", size = 2) +
  coord_flip() +
  labs(title = "Total Offences by Region", x = "Region", y = "Total Offences") +
  theme_classic()

# Generate a scatter plot to visualize the rate per 1,000 population by region
ggplot(regional_summary, aes(x = reorder(Region_Name, avg_rate_per_1000), y = avg_rate_per_1000)) +
  geom_point(color = "darkorange", size = 3) +
  labs(title = "Rate per 1,000 Population by Region", x = "Region", y = "Rate per 1,000 Population") +
  theme_light() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Identify the three counties with the lowest total crimes
low_offence_regions <- regional_summary %>%
  arrange(total_offences) %>%
  slice(1:3)

# Create a lollipop chart for regions with the lowest total offences, using a minimal theme
ggplot(low_offence_regions, aes(x = reorder(Region_Name, total_offences), y = total_offences)) +
  geom_segment(aes(xend = Region_Name, yend = 0), color = "lightgreen") +
  geom_point(color = "darkgreen", size = 4) +
  coord_flip() +
  labs(title = "Regions with the Lowest Total Offences", x = "Region", y = "Offence Count") +
  theme_classic()
