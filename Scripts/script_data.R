##Script for extract informations from Instagram's JSON file to a "r" dataframe
library(jsonlite)
library(plyr)
library(stringr)
library(stringi)

#import data
setwd(" ")
liste_json = list.files(path = " ", pattern="*UTC.json", full.names = TRUE)
base_json = lapply(liste_json, fromJSON, flatten=TRUE)

#lenght of raw data
first_len = length(base_json)

#get a list with location
address_json= list()
for(i in 1:first_len){
  address_json[i] <- c(base_json[[i]][["node"]][["location"]][["address_json"]])
}

#remove NULL
r_null = compact(address_json)
#lenght of data who contain location
second_len = length(r_null) 

#regex manipulations
reg_a = sub("{", "", address_json, perl = TRUE)
reg_a = sub("}", "", reg_a, perl = TRUE)
reg_a = str_replace_all(reg_a,':', "")
reg_a = str_replace_all(reg_a,', ', ',')


#split informations
reg_data = strsplit(reg_a, '"')

#list for each informations
ls_street = list()
for(i in 1:first_len){
  ls_street[i] <- c(reg_data[[i]][4])
}
street=unlist(ls_street)
ls_zip = list()
for(i in 1:first_len){
  ls_zip[i] <- c(reg_data[[i]][8])
}
zip = unlist(ls_zip)
ls_city = list()
for(i in 1:first_len){
  ls_city[i] <- c(reg_data[[i]][12])
}
#see next step
ls_region = list()
for(i in 1:first_len){
  ls_region[i] <- c(reg_data[[i]][16])
}
region = unlist(ls_region)
ls_country = list()
for(i in 1:first_len){
  ls_country[i] <- c(reg_data[[i]][20])
}
country = unlist(ls_country)

#ls_city contain sometimes 2 informations 
ls_city_split = list()
for(i in 1:first_len){
  ls_city_split[i] <- strsplit(ls_city[[i]], ",")
}
ls_city_one = list()
for(i in 1:first_len){
  ls_city_one[i] <- c(ls_city_split[[i]][1])
}
city_one = unlist(ls_city_one)
ls_city_two = list()
for(i in 1:first_len){
  ls_city_two[i] <- c(ls_city_split[[i]][2])
}
city_two = unlist(ls_city_two)


#get a list with likes
likes_json= list()
for(i in 1:first_len){
  likes_json[i] <- c(base_json[[i]][["node"]][["edge_liked_by"]][["count"]])
}
likes = unlist(likes_json)

#get a list with owner's total posts
posts_json= list()
for(i in 1:first_len){
  posts_json[i] <- c(base_json[[i]][["node"]][["owner"]][["edge_owner_to_timeline_media"]][["count"]])
}
posts = unlist(posts_json)

#get an "id" for user from file name
id_json = basename(liste_json)
id_ = str_replace_all(id_json,"_", "")
id_s = str_replace_all(id_,"-", "")
id_sp = str_remove_all(id_s, "UTC.json")
ls_id_sp = list()
for(i in 1:first_len){
  ls_id_sp[i] <- c(id_sp[[i]][1])
}
id = unlist(ls_id_sp)

#get date from file's name
name_json = basename(liste_json)
name_sp = strsplit(name_json, "_")
ls_name_sp = list()
for(i in 1:first_len){
  ls_name_sp[i] <- c(name_sp[[i]][1])
}
date = unlist(ls_name_sp)

#picture URL per post
pic= list()
for(i in 1:first_len){
  pic[i] <- c(base_json[[i]][["node"]][["display_url"]])
}
pictures_link = unlist(pic)

#build a dataframe
df = data.frame(street, zip, city_one, city_two, region, country, date, likes,pictures_link, id)
df_address = data.frame(street, zip, city_one, city_two, region, country, id)


#save dataframe to csv file
write.csv(df, file = "data_venus_img.csv")
write.csv(df, file = "data_address_venus_img.csv")
