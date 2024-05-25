

turk_dat <- read_rds("https://github.com/favstats/TurkishElection2023/raw/9c883dca981a639b84e52a0243f0f7bd7fb36f6c/data/election_dat30.rds")

# tk <-  read_csv("C:/Users/fabio/Downloads/wtm-advertisers-tk-2024-03-07T20_50_19.334Z.csv")

report <- read_csv("C:/Users/fabio/Downloads/FacebookAdLibraryReport_2024-03-04_TR_last_30_days/FacebookAdLibraryReport_2024-03-04_TR_last_30_days_advertisers.csv") %>% 
  janitor::clean_names() %>% 
  mutate(page_id = as.character(page_id))

turk_dat %>% 
  distinct(page_id, party, total_spend_formatted) %>% 
  right_join(report) %>% 
  
  mutate(amount_spent_try  = parse_number(amount_spent_try )) %>% 
  rename(spend_30days_bf_may15_2023 = total_spend_formatted,
         spend_30days_bf_march4_2024 = amount_spent_try,
         n_ads_30days_bf_march4_2024 = number_of_ads_in_library) %>% 
  arrange(desc(spend_30days_bf_march4_2024)) %>% 
  mutate(facebook_link = paste0("https://www.facebook.com/", page_id),
         ad_library_link = paste0("https://www.facebook.com/ads/library/?active_status=all&ad_type=political_and_issue_ads&country=TR&view_all_page_id=",page_id, "&search_type=page&media_type=all")) %>% 
  # View()
  openxlsx::write.xlsx("turkey.xlsx")
  