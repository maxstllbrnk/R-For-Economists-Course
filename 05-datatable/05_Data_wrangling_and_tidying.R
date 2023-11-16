################################################################################
####Lecture 05: Data wrangling and tidying
################################################################################

####1. Tidyverse
#Tidy data is more likely to be long (narrow) format than wide format.
#1. Each variable forms a column
#2. Each observation forms a row
#3. Each type of observational unit forms a table

pacman::p_load("tidyverse", "nycflights13") #load needed packages

tidyverse_packages() #displays all the packages, some have to be loaded separatley e.g. lubridate, rvest
tidyverse_conflicts() #displays all the namespace conflicts

#Pipe operator: %>%
mpg %>% 
  filter(manufacturer == "audi") %>% 
  group_by(model) %>% 
  summarise(hwy_mean = mean(hwy))

##dplyr: important functions
#1. dplyr::filter(): Filter (i.e. subset) rows based on their values
starwars %>%
  filter(
    species == "Human", 
    height >= 190
  )

starwars %>%
  filter(grepl("Skywalker", name)) #Filter for names that contain the string "Skywalker"

starwars   %>%
  filter(is.na(height)) #Identify missing data cases
starwars %>%
  filter(!is.na(height)) #Remove missing observations 

#2. dplyr::arrange(): Arrange (i.e. reorder) rows based on their values
starwars %>%
  arrange(birth_year)
#Arranging on a character-based column will sort alphabetically

starwars %>%
  arrange(desc(birth_year)) #Arrange items in descending order

#3. dplyr::select(): Select (i.e. subset) columns by their names
#Use commas to select multiple columns out of a data frame
#Use "first:last" for consecutive columns
#Deselect a column with "-"

starwars %>%
  select(name:skin_color, species, -height)

#Rename some (or all) of your selected variables in place
starwars %>%
  select(alias = name, crib = homeworld, sex = gender)

#rename(): rename columns without subsetting them

#select(contains(PATTERN)) option provides a nice shortcut in relevant cases
starwars %>%
  select(name, contains("color"))

#select(..., everything()) option if you want to bring some variable(s) to the "front" of a data frame
starwars %>%
  select(species, homeworld, everything()) %>%
  head(5)

#relocate(): brought a lot more functionality to ordering of columns

#4. dplyr::mutate(): Create new columns
starwars %>%
  select(name, birth_year) %>%
  mutate(dog_years = birth_year * 7, 
         comment = paste0(name, " is ", dog_years, " in dog years."))

#Boolean, logical and conditional operators all work well with mutate too
starwars %>%
  select(name, height) %>%
  filter(name %in% c("Luke Skywalker", "Anakin Skywalker")) %>%
  mutate(tall1 = height > 180) %>%
  mutate(tall2 = ifelse(height > 180, "Tall", "Short")) #Same effect, but can choose labels

#Combining mutate and across feature allows to work on a subset of variables
starwars %>%
  select(name:eye_color) %>%
  mutate(across(where(is.character), toupper)) %>%
  head(5)
#toupper(): convert to upper case
#across(): apply the same transformation to multiple columns
#across(.cols, .fns, ..., .names = NULL, .unpack = FALSE)


#5. dplyr::summarise(): Collapse multiple rows into a single summary value
#Particularly useful in combination with the group_by command
starwars %>%
  group_by(species, gender) %>%
  summarise(mean_height = mean(height, na.rm = TRUE))
#Including "na.rm = TRUE" is good with the summarise function as otherwise any missing value will propagate to the summarised value

#The across-based workflow also works with summarise
starwars %>%
  group_by(species) %>%
  summarise(across(where(is.numeric), mean, na.rm = T))%>%
  head(5)

#ungroup(): for ungrouping

#6. slice(): Subset of rows by position rather than filtering by values
starwars %>%
  slice(c(1,5))

#7. pull(): Extract a column from the data frame as a vector or a scalar
starwars %>%
  filter(gender == "female") %>%
  pull(height)

#8. count() and distinct(): Number and isolate unique observations
starwars %>%
  count(species)
starwars %>%
  distinct(species)
#Could also use a combination of mutate, group_by and n()
starwars %>%
  group_by(species) %>%
  mutate(num = n()) #n() returns number of observations in a current group

##Joins:
pacman::p_load("nycflights13")
flights
planes
#1. inner_join(df1, df2): return all rows from x where there are matching values in y, and all columns from x and y. If there are multiple matches between x and y, all combination of the matches are returned.

#2. left_join(df1, df2): return all rows from x, and all columns from x and y. Rows in x with no match in y will have NA values in the new columns. If there are multiple matches between x and y, all combinations of the matches are returned.

left_join(flights, 
          planes %>% rename(year_built = year), #Not necessary w/ below line, but helpful
          by = "tailnum") %>%
  select(year, month, day, dep_time, arr_time, carrier, flight, tailnum, type, model)

#3. right_join(df1, df2): return all rows from y, and all columns from x and y. Rows in y with no match in x will have NA values in the new columns. If there are multiple matches between x and y, all combinations of the matches are returned.

#4. full_join(df1, df2): return all rows and all columns from both x and y. Where there are not matching values, returns NA for the one missing.

#5. semi_join(df1, df2): return all rows from x where there are matching values in y, keeping just columns from x.

#6. anti_join(df1, df2): return all rows from x where there are not matching values in y, keeping just columns from x.

##Key tidyr verbs:

#1. tidyr::pivot_longer(): Pivot wide format into long format (i.e. melt)
stocks = data.frame(
  time = as.Date('2009-01-01') + 0:1,
  X = rnorm(2, 0, 1),
  Y = rnorm(2, 0, 1),
  Z = rnorm(2, 0, 1)
)

stocks

tidy_stocks <- stocks %>%
  pivot_longer(-time, names_to = "stock", values_to = "price")

#2. tidyr::pivot_wider(): Pivot long data into wide format (i.e. cast)
tidy_stocks %>%
  pivot_wider(names_from = stock, values_from = price)

tidy_stocks %>%
  pivot_wider(names_from = time, values_from = price) #transposes the original data

#3. tidyr::separate(): Separate (i.e. split) one column into multiple columns
economists <- data.frame(name = c("Adam.Smith", "Paul.Samuelson", "Milton.Friedman"))
economists

economists %>%
  separate(name, c("first_name", "last_name"))

#separate_rows(): split up cells that contain multiple fields or observations
jobs <- data.frame(
  name = c("Jack", "Jill"),
  occupation = c("Homemaker", "Philosopher, Philanthropist, Troublemaker")
)
jobs

jobs %>%
  separate_rows(occupation)

#4. tidyr::unite(): Unite (i.e. combine) multiple columns into one
gdp = data.frame(
  yr = rep(2016, times = 4),
  mnth = rep(1, times = 4),
  dy = 1:4,
  gdp = rnorm(4, mean = 100, sd=2)
)
gdp

gdp_u <- gdp %>%
  unite(date, c("yr", "mnth", "dy"), sep="-")
#unite will automatically create a character variable

pacman::p_load(lubridate) #date data_type
gdp_u %>% mutate(date = ymd(date))

#5. tidyr::crossing(): Get the full combination of a group of variables
crossing(side=c("left", "right"), height=c("top", "bottom"))

####Summary key verbs

##dplyr
#filter
#arrange
#select
#mutate
#summarise

##tidyr
#pivot_longer
#pivot_wider
#separate
#unite

##Others
#group_by
#join-functions
#etc.


