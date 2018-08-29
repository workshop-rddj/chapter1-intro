#--------------------------------------------------------------------
# 1. 데이터
#--------------------------------------------------------------------

# 아래 각각의 데이터셋 구조를 살펴봅시다
# iris 데이터셋의 변형에 따른 열은 어떻게 달라졌나요?
str(iris)
str(iris.wide)
str(iris.tidy)


# Rplot.jpg와 같은 차트를 만드려면 어떤 데이터를 써서 만들어야할까요?
ggplot(___, aes(x = ___, y = ___, col = ___)) +
  geom_jitter() +
  facet_grid(. ~ ___)

ggplot(iris.tidy, aes(x = Species, y = Value, col = Part)) +
  geom_jitter() +
  facet_grid(. ~ Measure)

# iris.tidy를 만들어보자
iris.tidy <- iris %>%
  gather(key, Value, -Species) %>%
  separate(key, c("Part", "Measure"), "\\.")

# 이번에는 iris.wide를 사용한다
head(iris)
head(iris.wide)
head(iris.tidy)

# 어떤 데이터를 써서 Rplot01처럼 만들 수 있을까?
ggplot(iris.wide, aes(x = Length, y = Width, color = Part)) +
  geom_jitter() +
  facet_grid(. ~ Species)

# iris.wide 데이터 만들기
# Load the tidyr package
library(tidyr)

# Add column with unique ids (don't need to change)
iris$Flower <- 1:nrow(iris)

head(iris)
# Fill in the ___ to produce to the correct iris.wide dataset
iris.wide <- iris %>%
  gather(key, value, -Species, -Flower) %>%
  separate(key, c("Part", "Measure"), "\\.") %>%
  spread(Measure, value)