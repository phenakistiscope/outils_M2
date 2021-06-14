##script for cleaning txt data to get hashtags per post
library("stringr")
library("stringi")
library("dplyr")
library("tidyr")


#import data txt
setwd(" ")
liste_txt = list.files(path = " ", pattern="*UTC.txt", full.names = TRUE)
base_txt = lapply(liste_txt, readLines)

#convert to a string
ls_text = list()
for(i in 1:length(base_txt)){
  ls_text[i] <- toString(base_txt[[i]])
}

#convert to a vector of words with #, and dataframe
hash_txt = stri_extract_all(ls_text, regex = "#[:alnum:]+")
hash_low = lapply(hash_txt, tolower)
df_str = lapply(hash_low, toString)
txt = str_remove_all(df_str, "[\"#,]")

#build a dataframe for each post and hashtag they contain
leng = lapply(hash_low, `length<-`, max(lengths(hash_low)))
f = function(x) data.frame(x)
df_hash = lapply(leng, f)
dff = list()
for(i in 1:length(df_hash)){
  dff[i] <- cbind(df_hash[[i]])
}

df_txt_hash = data.frame(dff)

#build id with file's name as the other scripts
id_txt = basename(liste_txt)
id_ = str_replace_all(id_txt,"_", "")
id_s = str_replace_all(id_,"-", "")
id_sp = str_remove_all(id_s, "UTC.txt")
ls_id_sp = list()
for(i in 1:length(id_sp)){
  ls_id_sp[i] <- c(id_sp[[i]][1])
}
id = unlist(ls_id_sp)

#dataframe with "id" and hashtags per posts
df_txt = data.frame(id, txt)
#change daf_txt_hash column names
names(df_txt_hash) <- c(id)
final_df <- as.data.frame(t(df_txt_hash))


##save to csv
write.csv(df_txt, file ="id_txt_venus.csv")
write.csv(df_txt_hash, file ="id_hash_venus.csv")
#write.csv2(final_df, file ="gephi_.csv", na = " ")


