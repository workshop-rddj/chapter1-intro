library(tidyverse)

# read csv
df_early <- read_csv("data/subway2017_early.csv")
df_end <- read_csv("data/subway2017_end.csv")

# na 제거
df_total <- rbind(df_early, df_end) %>% 
  drop_na()

# 컬럼이름 변경
colnames(df_total) <- c("date", "day", "code", "name", "category", 
                        "1_2", "2_3", "3_4", "4_5", "5_6", "6_7", 
                        "7_8", "8_9", "9_10", "10_11", "11_12", 
                        "12_13", "13_14", "14_15", "15_16", "16_17", 
                        "17_18", "18_19", "19_20", "20_21", "21_22", 
                        "22-23", "23_24", "24_1")

# NA 및 기본적인 사항 확인
unique(df_total$day)
unique(df_total$category)
unique(df_total$name)
unique(df_total$code)

# Month 따로 추출
df_total <- df_total %>% 
  mutate(month = str_sub(date,5,6))

###################################################
# 승차 및 하차를 가장 많이 한 지하철역
###################################################
glimpse(df_total)
df_total$name <- str_squish(df_total$name)
df_total$name <- str_replace_all(df_total$name, " ", "")

df_total <- df_total %>% 
  gather("time", "value", 6:29)

# 승차
analy1 <- df_total %>% filter(category == "승차") %>% 
  group_by(category, name) %>% 
  summarise(total = sum(value)) %>% 
  arrange(desc(total)) %>% ungroup()

# 하차
analy2 <- df_total %>% filter(category == "하차") %>% 
  group_by(category, name) %>% 
  summarise(total = sum(value)) %>% 
  arrange(desc(total)) %>% ungroup()

ggplot(analy1, aes(x=name, y=total)) +
  geom_bar(stat = "identity") +
  theme_fivethirtyeight(base_family = "NanumGothic")

ggplot(analy2, aes(x=name, y=total)) +
  geom_bar(stat = "identity") +
  theme_fivethirtyeight(base_family = "NanumGothic")

###################################################
# 평일과 주말을 구분해보자
###################################################
weekend <- df_total %>% filter(day == "토" | day == "일")
weekdays <- df_total %>% filter(day == "월" | day == "화" | day == "수" |
                                  day == "목" | day == "금")

###################################################
# 주말 승차
###################################################
analy3 <- weekend %>% filter(category == "승차") %>% 
  group_by(category, name) %>% 
  summarise(total = sum(value)) %>% 
  arrange(desc(total)) %>% ungroup()

###################################################
# 평일 승차
###################################################
analy4 <- weekdays %>% filter(category == "승차") %>% 
  group_by(category, name) %>% 
  summarise(total = sum(value)) %>% 
  arrange(desc(total)) %>% ungroup()

###################################################
# 주말 하차
###################################################
analy5 <- weekend %>% filter(category == "하차") %>% 
  group_by(category, name) %>% 
  summarise(total = sum(value)) %>% 
  arrange(desc(total)) %>% ungroup()

###################################################
# 평일 하차
###################################################
analy6 <- weekdays %>% filter(category == "하차") %>% 
  group_by(category, name) %>% 
  summarise(total = sum(value)) %>% 
  arrange(desc(total)) %>% ungroup()

###################################################
# 시간대별
###################################################
analy7 <- df_total %>% 
  group_by(time, name) %>% 
  summarise(total = sum(value)) %>%
  arrange(desc(total)) %>% 
  ungroup()

# 출퇴근 시간대
analy7_commute <- analy7 %>% 
  filter(time == "7_8" | time == "8_9" | time == "18_19" | time == "19_20")

#ggplot(analy7_commute, aes(x=name, y=total, fill=time)) +
#  geom_bar(stat = "identity") +
#  theme_fivethirtyeight(base_family = "NanumGothic") +
#  facet_grid(~name)

df_total %>% group_by(day, name, category, time) %>% 
  summarise(total = sum(value)) %>% 
  arrange(desc(total)) %>% 
  ungroup() %>% 
  filter(day == "금", category == "하차") %>% 
  View()

df_total <- df_total %>%
  mutate(isFriday = if_else(day == "금", "불금", 
                            if_else(day == "토" & day == "일", "주말", "평일")))


isFri <- df_total %>%
  filter(time == "18_19" | time == "19_20") %>% 
  group_by(isFriday, name, time) %>% 
  summarise(total = mean(value))

head(df_total)
fri_dongrae <- df_total %>% 
  filter(name == "동래" & time == "18_19") %>% 
  group_by(day) %>% 
  summarise(total = sum(value))

