################################################################################
####Introduction
################################################################################

#With pacman load and install packages
pacman::p_load(ggplot2, gapminder)

head(gapminder)

#"Grammar" of ggplot2
#1. The plot ("the visualization") is linked to the variables ("the data") through various aesthetic mappings
#2. Once the aesthetic mappings are defined, the data can be represented in different ways by choosing different geoms (i.e. "geometric objects" like points, lines, or bars)
#3. The plot is built in layers

#plot lifeExp vs. gdpPerCap
ggplot(data=gapminder, mapping = aes(x = gdpPercap, y = lifeExp, size = pop, color = continent))+
  geom_point(alpha = 0.3) # alpha controls the transperency

ggplot(data = gapminder, aes(x = gdpPercap, y = lifeExp)) + ## Applicable to all geoms
  geom_point(aes(size = pop, col = continent), alpha = 0.3) ## Applicable to this geom only

#save an intermediate plot instead of repeating the same ggplot every time
p = ggplot(data = gapminder, aes(x = gdpPercap, y = lifeExp))
p +
  geom_point(alpha=0.3, aes(size=pop, color=continent))+
  geom_smooth(method="loess")

ggplot(data = gapminder) +
  geom_density(aes(x = gdpPercap, fill = continent), alpha=0.3)
