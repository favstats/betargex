# 
# print("hello")
# 
# print(getwd())

all_dat <- readRDS("../data/all_dat.rds")

# print("hello")

sets <- jsonlite::fromJSON("../settings.json")




options(scipen = 999)


# wtm_data %>% count(party,sort = T)


# source("../party_utils.R")
color_dat <- tibble(
  party = c("N-VA", "Vlaams Belang", "PS", "CD&V", "PVDA", "MR", "Ecolo", 
            "Groen", "DéFI", "Les Engagés", "Open Vld", "Vooruit"),
  colors = c("#f9ce19", "#000000", "#ff0000", "#ff6200", "#8b0000", "#1f5db5", "#6eb651", 
             "#01796f", "#df1e8f", "#00e6d2", "#0087dc", "#c60000")
)

most_left_party <- "Groen"


scale_fill_parties <- function(...){
  ggplot2:::manual_scale(
    'fill',
    values = setNames(color_dat$colors, color_dat$party),
    ...
  )
}
scale_color_parties <- function(...){
  ggplot2:::manual_scale(
    'color',
    values = setNames(color_dat$colors, color_dat$party),
    ...
  )
}


election_dat30 <- readRDS("../data/election_dat30.rds") %>%
  # left_join(all_dat) %>%
  rename(internal_id = page_id) %>%
  filter(party != "Aut")  %>%
  filter(is.na(no_data)) %>% 
  mutate(party = case_when(
    party == "NVA" ~ "N-VA",
    party == "VB" ~ "Vlaams Belang",
    party == "PS" ~ "PS",
    party == "V" ~ "Vooruit",
    party == "CDV" ~ "CD&V",
    party == "Eco" ~ "Ecolo",
    party == "GRO" ~ "Groen",
    party == "Eng" ~ "Les Engagés",
    party == "Open VLD" ~ "Open Vld",
    T ~ party
  )) %>% 
  drop_na(party)



election_dat7 <- readRDS("../data/election_dat7.rds") %>%
  # left_join(all_dat) %>%
  rename(internal_id = page_id) %>%
  filter(party != "Aut")  %>%
  filter(is.na(no_data)) %>% 
  mutate(party = case_when(
    party == "NVA" ~ "N-VA",
    party == "VB" ~ "Vlaams Belang",
    party == "PS" ~ "PS",
    party == "V" ~ "Vooruit",
    party == "CDV" ~ "CD&V",
    party == "Eco" ~ "Ecolo",
    party == "GRO" ~ "Groen",
    party == "Eng" ~ "Les Engagés",
    party == "Open VLD" ~ "Open Vld",
    T ~ party
  )) %>% 
  drop_na(party)


# saveRDS(election_dat30, "../data/election_dat30.rds")
# saveRDS(election_dat7, "../data/election_dat7.rds")

fin <- (as.Date(election_dat30$ds[1])-lubridate::days(1))
begin7 <- fin-lubridate::days(6)
begin30 <- fin-lubridate::days(29)

tibble(fin,
       begin7,
       begin30) %>% 
  write_csv("../data/dates.csv")


# Setting the system locale to Dutch for time/date formatting
Sys.setlocale("LC_TIME", "nl_NL")

# Function to create Dutch date strings with suffixes
create_date <- function(x) {
  the_date <- format(x, "%e %b") # %e for day of the month without leading zeros, %B for full month name in Dutch
  # In Dutch, date suffixes are not commonly used so we can omit the 'append_date_suffix' part
  return(trimws(the_date)) # trimws to remove any leading or trailing whitespace which might be left after %e
}

last7days_string <- paste0(create_date(begin7), " - ", create_date(fin), " ", lubridate::year(fin)) %>% str_replace("Oct", "Okt")
last30days_string <- paste0(create_date(begin30), " - ", create_date(fin), " ", lubridate::year(fin)) %>% str_replace("Oct", "Okt")

# # Print the Dutch date range strings
# print(last7days_string)
# print(last30days_string)
# 
# # Reset locale back to the original if necessary
# Sys.setlocale("LC_TIME", "C")





the_currency <- election_dat30 %>%
  count(main_currency, sort = T) %>%
  slice(1) %>%
  pull(main_currency)

if(the_currency == "EUR"){
  currency_symbol <- "€"
} else if(the_currency=="INR"){
  currency_symbol <- "₹"
} else {
  currency_symbol <- the_currency
}

