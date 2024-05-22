# Install and load necessary packages
# install.packages("highcharter")
# install.packages("dplyr")
library(highcharter)
library(dplyr)

# Sample data
data <- data.frame(
  x = c(1, 2, 3, 4, 5),
  y = c(10, 20, 30, 40, 50),
  size = c(15, 25, 35, 45, 55),
  logo = c("https://upload.wikimedia.org/wikipedia/commons/7/76/Groen_logo_2022.png", "https://upload.wikimedia.org/wikipedia/commons/7/76/Groen_logo_2022.png", "https://upload.wikimedia.org/wikipedia/commons/7/76/Groen_logo_2022.png", "https://upload.wikimedia.org/wikipedia/commons/7/76/Groen_logo_2022.png", "https://upload.wikimedia.org/wikipedia/commons/7/76/Groen_logo_2022.png")
)

data <- data.frame(
  x = c(1, 2, 3, 4, 5),
  y = c(10, 20, 30, 40, 50),
  size = c(15, 25, 35, 45, 55),
  logo = c("https://www.svgrepo.com/show/27082/petronas-towers.svg", 
           "https://www.svgrepo.com/show/1171/tower-of-pisa.svg", 
           "https://www.svgrepo.com/show/19456/tokyo-tower.svg", 
           "https://www.svgrepo.com/show/27081/ahu-tongariki.svg", 
           "https://www.svgrepo.com/show/16763/empire-state-building.svg")
)

highchart() |> 
  hc_add_dependency("modules/pattern-fill.js") |> 
  hc_chart(type = "packedbubble") |> 
  hc_size(heigh = 350) |> 
  # hc_xAxis(type = 'category') |> 
  hc_tooltip(
    borderColor = "#CACACA",
    pointFormat = 'The size for <b>{point.name}</b> is <b>{point.z}</b>'
  ) |> 
  hc_add_series(
    data = list(
      list(
        x = 1,
        y = 10,
        z = 15,
        name = "Petronas",
        color = list(
          pattern = list(
            image = 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Groen_logo_2022.svg/404px-Groen_logo_2022.svg.png?20220929203627',
            aspectRatio = 1
          )
        )
      ),
      list(
        x = 2,
        y = 20,
        z = 25,
        name = 'Pisa',
        color = list(
          pattern = list(
            image = 'https://commons.wikimedia.org/wiki/File:Groen_logo_2022.svg',
            aspectRatio = 1
          )
        )
      ),
      list(
        x = 3,
        y = 30,
        z = 35,
        name = 'Eiffel tower',
        color = list(
          pattern = list(
            image = 'https://commons.wikimedia.org/wiki/File:Groen_logo_2022.svg',
            aspectRatio = 1
          )
        )
      ),
      list(
        x = 4,
        y = 40,
        z = 45,
        name = 'Ahu-tongariki',
        color = list(
          pattern = list(
            image = 'https://commons.wikimedia.org/wiki/File:D%C3%A9FI_logo.svg',
            aspectRatio = 1
          )
        )
      ),
      list(
        x = 5,
        y = 50,
        z = 55,
        name = 'Empire State',
        color = list(
          pattern = list(
            image = 'https://upload.wikimedia.org/wikipedia/commons/c/cf/Groen_logo_2022.svg',
            aspectRatio = 0.9
          )
        )
      )
    ),
    name = 'Landmarks'
  )


library(visNetwork)

path_to_images <- "https://raw.githubusercontent.com/datastorm-open/datastorm-open.github.io/master/visNetwork/data/img/indonesia/"

nodes <- data.frame(id = 1:4, 
                    shape = c("image", "image"),
                    image = c("https://commons.wikimedia.org/wiki/File:D%C3%A9FI_logo.svg",
                             "https://commons.wikimedia.org/wiki/File:D%C3%A9FI_logo.svg", "https://commons.wikimedia.org/wiki/File:Groen_logo_2022.svg", "https://commons.wikimedia.org/wiki/File:D%C3%A9FI_logo.svg"),
                    label = "I'm an image")

edges <- data.frame(from = c(2,4,3,3), to = c(1,2,4,2))

visNetwork(nodes, edges, width = "100%") %>% 
  visNodes(shapeProperties = list(useBorderWithImage = TRUE)) %>%
  visLayout(randomSeed = 2)




highchart() %>% 
  hc_add_dependency("modules/pattern-fill.js") %>% 
  hc_chart(type = "venn") %>% 
  hc_add_series(
    dataLabels = list(style = list(fontSize = "20px")),
    name = "Venn Diagram",
    data = list(
      list(
        name = "Petronas",
        sets = list("A"), 
        value = 5,
        color = list(
          pattern = list(
            image = 'https://commons.wikimedia.org/wiki/File:D%C3%A9FI_logo.svg',
            aspectRatio = 1.3
          )
        )
      ),
      list(
        name = "Pisa",
        sets = list("B"), 
        value = 2,
        color = list(
          pattern = list(
            image = 'https://upload.wikimedia.org/wikipedia/commons/c/cf/Groen_logo_2022.svg',
            aspectRatio = 1
          )
        )
      ),
      list(
        name = "Eiffel tower",
        sets = list("C"), 
        value = 12,
        color = list(
          pattern = list(
            image = 'https://www.svgrepo.com/show/19456/tokyo-tower.svg',
            aspectRatio = 0.8
          )
        )
      ),
      list(
        name = "Ahu-tongariki",
        sets = list("D"), 
        value = 20,
        marker = list(symbol = sprintf("url(%s)", ahu))
        
      ),
      list(
        name = "Empire State",
        sets = list("E"), 
        value = 15,
        marker = list(symbol = sprintf("url(%s)", ahu))
      )
    )
  )














data <- data.frame(
  party = c("Party A", "Party A", "Party B", "Party B", "Party C"),
  candidate = c("Candidate 1", "Candidate 2", "Candidate 3", "Candidate 4", "Candidate 5"),
  spending = c(100000, 150000, 200000, 250000, 300000)
)

data <- election_dat30 %>% 
  distinct(internal_id, .keep_all = T) %>% 
  group_by(party) %>% 
  arrange(desc(total_spend_formatted)) %>% 
  slice(1:5) %>% 
  ungroup() 

thedata <- election_dat30 %>% 
  distinct(internal_id, .keep_all = T) %>% 
  group_by(party) %>% 
  summarize(total_spend_formatted = sum(total_spend_formatted)) %>% 
  ungroup()

highchart() %>%
  hc_chart(type = "venn") %>%
  hc_add_series(
    dataLabels = list(style = list(fontSize = "20px")),
    name = "Venn Diagram",
    data = lapply(1:nrow(thedata), function(i) {
      list(
        name = thedata$party[i],
        sets = list(thedata$party[i]),
        value = thedata$total_spend_formatted[i]
      )
    })
  ) %>%
  hc_tooltip(
    useHTML = TRUE,
    pointFormat = "<b>{point.name}:</b> {point.value}"
  )


hc <- hchart(data, "packedbubble", hcaes(name = page_name, value = total_spend_formatted, group = party))

hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    pointFormat = "<b>{point.name}:</b> {point.value}"
  ) %>% 
  hc_plotOptions(
    packedbubble = list(
      maxSize = "150%",
      zMin = 0,
      layoutAlgorithm = list(
        gravitationalConstant = 0.05,
        splitSeries = TRUE, # TRUE to group points by series
        seriesInteraction = TRUE,
        dragBetweenSeries = TRUE,
        parentNodeLimit = TRUE
      ),
      dataLabels = list(
        enabled = TRUE,
        format = "{point.name}",
        style = list(
          color = "black",
          textOutline = "none",
          fontWeight = "normal"
        )
      )
    )
  )

