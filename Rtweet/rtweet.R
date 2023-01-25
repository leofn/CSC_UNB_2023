# install.packages("rtweet", repos = 'https://ropensci.r-universe.dev')
library(rtweet)
library(tidyverse)
library(tidytext)
# autorização simples
auth_setup_default()

# salvando 1000 tweets com "#chatgpt"
chatgpt <- censusTweets <- search_tweets(q="#chatGPT",n=1000, include_rts = FALSE, lang='pt-br')

analise_mensagem <- chatgpt %>%
  unnest_tokens(text,text,to_lower = TRUE) %>%
  count(created_at, text, sort = TRUE) %>%
  ungroup()

total_palavras <- analise_mensagem %>%
  group_by(created_at) %>%
  summarize(total=sum(n))

analise_mensagem <- inner_join(analise_mensagem, total_palavras)

analise_mensagem <- analise_mensagem %>%
  bind_tf_idf(text, created_at, n) %>%
  filter(tf_idf>=0.01)


stop_words_grupo <- unique(tm::stopwords("pt"))
stop_words_grupo <- c(stop_words_grupo,"8furu9tkzx","mxjapmblko", c('t.co','arquivo','é','https','http','q','tão','aí','10','1','tá',c('2013':'2020')))

analise_mensagem %>%
  anti_join(data_frame(text = stop_words_grupo)) %>%
  group_by(text)%>%
  summarise(
    n = sum(n)
  ) %>%
  filter(n >= 45) %>%
  ungroup() %>%
  mutate(text = reorder(text, n)) %>%
  ggplot(aes(x=text, y=n)) +
  geom_segment(aes(x=text, xend=text, y=0, yend=n ) ) +
  geom_point(color = "orange" ) +
  theme_light(base_size = 12, base_family = "") +
  coord_flip() +
  theme(
    legend.position="none",
    panel.grid.major.y = element_blank(),
    axis.ticks.length = unit(.99, "cm"),
    panel.border = element_blank(),
    axis.ticks.y = element_blank()
  ) +
  xlab("") 

library(wordcloud)
analise_mensagem %>%
  anti_join(data_frame(text = stop_words_grupo)) %>%
  group_by(text)%>%
  summarise(
    n = sum(n)
  ) %>%
  with(wordcloud(text,n,max.words = 15, colors=brewer.pal(6,"Dark2"),random.order=FALSE))
