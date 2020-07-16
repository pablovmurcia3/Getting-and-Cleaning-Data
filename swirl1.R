
library(swirl)
swirl()

# One unique aspect of dplyr is that the same set of tools allow you to work with
# tabular data from a variety of sources, including data frames, data tables, databases
# and multidimensional arrays

mydf <- read.csv(path2csv, stringsAsFactors = FALSE)

dim(mydf)

head(mydf)

library(dplyr)

packageVersion("dplyr") 
# The first step of working with data in dplyr is to load the data into what the
# package authors call a 'data frame tbl' or 'tbl_df'

cran <- tbl_df(mydf)

rm("mydf")

?tbl_df

cran # better visualization

#  Specifically, dplyr supplies five 'verbs' that cover most fundamental data
# manipulation tasks: select(), filter(), arrange(), mutate(), and summarize().

?select

select(cran, ip_id, package, country) # to select only the ip_id, package, and 
# country variables from the cran dataset.

select(cran,r_arch:country)

select(cran,country:r_arch)

cran

select(cran, -time)

select(cran, -(X:size))

filter(cran, package == "swirl")
# The == operator asks whether the thing on the left is equal to the thing on the
# right. If yes, then it returns TRUE. If no, then FALSE. In this case, package is an
# entire vector (column) of values, so package == "swirl" returns a vector of TRUEs and
# FALSEs. filter() then returns only the rows of cran corresponding to the TRUEs.

filter(cran, r_version == "3.1.1", country == "US")

filter(cran, r_version <= "3.0.2", country == "IN")

filter(cran, country == "US" | country == "IN") 
# will gives us all rows for which the country variable equals either "US" or
# "IN". Give it a go.

filter(cran, size > 100500,  r_os == "linux-gnu")

is.na(c(3, 5, NA, 10))

!is.na(c(3, 5, NA, 10))

filter(cran, !is.na(r_version))

cran2 <- select(cran, size:ip_id)

arrange(cran2, ip_id)

arrange(cran2, desc(ip_id))

arrange(cran2, package, ip_id)
# We can also arrange the data according to the values of multiple variables. For
# example, arrange(cran2, package, ip_id) will first arrange by package names
# (ascending alphabetically), then by ip_id. This means that if there are multiple rows
# with the same value for package, they will be sorted by ip_id (ascending numerically)

arrange(cran2, country, desc(r_version), ip_id)

cran3 <- select(cran, ip_id, package, size)

cran3

mutate(cran3, size_mb = size / 2^20)

mutate(cran3, size_mb = size / 2^20,  size_gb = size_mb / 2^10)

mutate(cran3, correct_size = size + 1000)

summarize(cran, avg_bytes = mean(size))

# ummarize() is most useful when working with data that has been grouped by the
# values of a particular variable.

# We'll look at grouped data in the next lesson, but the idea is that summarize() can
# give you the requested value FOR EACH group in your dataset.

################################################################################

# The main idea behind grouping data is that you want to break up your dataset into
# groups of rows based on the values of one or more variables. The group_by() function
# is reponsible for doing this.

library(dplyr)

cran <- tbl_df(mydf)

rm("mydf")

cran

?group_by

by_package <- group_by(cran, package)
# At the top of the output above, you'll see 'Groups: package', which tells us that
# this tbl has been grouped by the package variable. Everything else looks the same,
# but now any operation we apply to the grouped data will take place on a per package
# basis.

by_package

class(by_package)


summarize(by_package, mean(size) )


pack_sum <- summarize(by_package,
                      count = n(),
                      unique = n_distinct(ip_id),
                      countries = n_distinct(country),
                      avg_bytes = mean(size) )
submit()

pack_sum

quantile(pack_sum$count, probs = 0.99)

top_counts <- filter(pack_sum, count > 679)

top_counts

View(top_counts)

top_counts_sorted <- arrange(top_counts, desc(count))

View(top_counts_sorted)

quantile(pack_sum$unique, probs = 0.99)

top_unique <- filter(pack_sum, unique > 465 )

View(top_unique)

top_unique_sorted <- arrange(top_unique, desc(unique))

View(top_unique_sorted)

# called 'chaining' (or 'piping')

# Chaining allows you to string together multiple function calls in a way that is
# compact and readable

# The benefit of %>% is that it
# allows us to chain the function calls in a linear fashion. The code to the right of
# %>% operates on the result from the code to the left of %>%.

result3 <-
        cran %>%
        group_by(package) %>%
        summarize(count = n(),
                  unique = n_distinct(ip_id),
                  countries = n_distinct(country),
                  avg_bytes = mean(size)
        ) %>%
        filter(countries > 60) %>%
        arrange(desc(countries), avg_bytes)

# Print result to console
print(result3)

View(result3)


cran %>%
        select(ip_id, country, package, size) %>% 
        mutate(size_mb = size / 2^20) %>%
        filter(size_mb <= 0.5) %>%
        arrange(desc(size_mb)) %>% print

submit()

################################################################################

install.packages("tidyr")

swirl()

library(tidyr)

# Tidy data is formatted in a standard way that facilitates exploration and analysis
# and works seamlessly with other tidy data tools. Specifically, tidy data satisfies
# three conditions:
         
#         1) Each variable forms a column
 
#         2) Each observation forms a row
 
#         3) Each type of observational unit forms a table


# The first problem is when you have column headers that are values, not variable
# names. I've created a simple dataset called 'students' that demonstrates this
# scenario.

students

?gather

gather(students, sex, count, -grade) # Note the minus sign before grade, which says we
# want to gather all columns EXCEPT grade.

students2

res<-gather(students2, sex_class, count, -grade)

res

?separate

separate(data = res, col = sex_class, into = c("sex","class"))
# Conveniently, separate() was able to figure out on its own how to separate the
# sex_class column. Unless you request otherwise with the 'sep' argument, it splits on
# non-alphanumeric values. In other words, it assumes that the values are separated by
# something other than a letter or number (in this case, an underscore.)

# just like with dplyr, you can use the %>% operator to chain multiple function 
# calls together.

students2 %>%
        gather(sex_class,count, -grade ) %>%
        separate( col= sex_class, c("sex", "class")) %>%
        print

students3

students3 %>%
        gather(class, grade, class1:class5, na.rm = TRUE) %>%
        spread( test, grade ) %>%
        print


library(readr)

parse_number("class5")

students3 %>%
        gather(class, grade, class1:class5, na.rm = TRUE) %>%
        spread(test, grade) %>%
        mutate(class = parse_number(class))%>% 
        print

submit()


# table 1
student_info <- students4 %>%
        select(id, name, sex) %>%
        unique %>%
        print

# table 2

gradebook <- students4 %>%
        select(id, class, midterm, final)  %>%
        print


passed 
failed

passed <- mutate(passed, status = "passed")

failed <- mutate(failed, status = "failed")

bind_rows(passed, failed)
?bind_rows

sat %>%
        select(-contains("total")) %>%
        gather(part_sex, count, -score_range) %>%
        separate(part_sex, c("part", "sex")) %>%
        group_by(part,sex) %>%
        mutate( total =sum(count), prop = count/ total
        ) %>% print
