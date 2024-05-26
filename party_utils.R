# 
# print("hello")
# 
# print(getwd())

all_dat <- readRDS("../data/all_dat.rds")

# print("hello")

sets <- jsonlite::fromJSON("../settings.json")




options(scipen = 999)


# wtm_data %>% count(party,sort = T)

wtm_data <- read_csv("../data/07e893b0-0703-4f8e-b587-9cf3b811c31b.csv.gzip")  #names
  
# wtm_data %>% 
  # select(party = entities.short_name, colors = entities.color) %>% 
  # distinct() %>% 
  # filter(party != "Aut") %>% 
  # mutate(party = case_when(
  #   party == "NVA" ~ "N-VA",
  #   party == "VB" ~ "Vlaams Belang",
  #   party == "PS" ~ "PS",
  #   party == "V" ~ "Vooruit",
  #   party == "CDV" ~ "CD&V",
  #   party == "Eco" ~ "Ecolo",
  #   party == "GRO" ~ "Groen",
  #   party == "Eng" ~ "Les Engagés",
  #   party == "Open VLD" ~ "Open Vld",
  #   T ~ party
  # )) %>% 
  # dput()

# source("../party_utils.R")
color_dat <- structure(list(party = c("MR", "Les Engagés", "N-VA",
                                      "Ecolo", "Vlaams Belang", "CD&V",
                                      "Open Vld", "Groen", "PVDA", 
                                      "Vooruit", "PS", "DéFI",
                                      "ProDG", "l'Unie", "Blanco",
                                      "B.U.B.", "DierAnimal", "Viva Palestina",
                                      "Voor U"), 
                            colors = c("#0047AB", "#02E5D2", "#F9CE19",
                                       "#5aad39", "#000000", "#FF6200",
                                       "#0087DC", "#01796F", "#8B0000",
                                       "#b60000", "#FF0000", "#DD0081",
                                       "#6000a0", "#0000a0", "#D3D3D3",
                                       "#A1cccc", "#C99990", "#C99000",
                                       "#A99099")), row.names = c(NA, -19L
                                                                                                         ), class = c("tbl_df", "tbl", "data.frame"))

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
  mutate(total_spend_formatted = str_remove_all(total_spend_formatted, "\\.") %>% as.numeric) %>%
  # select(total_spend_formatted) %>%
  rename(internal_id = page_id) %>%
  filter(party != "Aut")  %>%
  filter(is.na(no_data)) %>%
  mutate(
    party = case_when(
      party == "NVA" ~ "N-VA",
      party == "VB" ~ "Vlaams Belang",
      party == "PS" ~ "PS",
      party == "V" ~ "Vooruit",
      party == "VU" ~ "Voor U",
      party == "CDV" ~ "CD&V",
      party == "Eco" ~ "Ecolo",
      party == "PB" ~ "Blanco",
      party == "GRO" ~ "Groen",
      party == "Eng" ~ "Les Engagés",
      party == "Open VLD" ~ "Open Vld",
      T ~ party
    )
  ) %>%
  drop_na(party)



election_dat7 <- readRDS("../data/election_dat7.rds") %>%
  # left_join(all_dat) %>%
  mutate(total_spend_formatted = str_remove_all(total_spend_formatted, "\\.") %>% as.numeric) %>%
  # select(total_spend_formatted) %>%
  rename(internal_id = page_id) %>%
  filter(party != "Aut")  %>%
  filter(is.na(no_data)) %>% 
  mutate(party = case_when(
    party == "NVA" ~ "N-VA",
    party == "VB" ~ "Vlaams Belang",
    party == "PS" ~ "PS",
    party == "V" ~ "Vooruit",
    party == "VU" ~ "Voor U",
    party == "PB" ~ "Blanco",
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

