library(ggplot2); library(ragg); library(sf); library(data.table)

hc <- fread('data derived/survdat_names_sed.csv')
hc <- hc[comname == 'horseshoe crab']

# Note that at some point they start recording crab sexes separately
hc <- unique(hc, by = c('cruise6', 'station', 'stratum', 'tow', 'year', 'season',
                         'catchsex'))
hc <- hc[, lapply(.SD, sum),
         .SDcol = c('abundance', 'biomass'),
         by = c('cruise6', 'station', 'stratum', 'tow', 'year', 'season', 'lat', 'lon')]

hc <- st_as_sf(hc,
               coords = c('lon', 'lat'),
               crs = 4326)

coast <- read_sf('data/mapping/coast_crop.shp')


agg_png('figures/horseshoecrab_fallabundance_5yrly.png',
        width = 5,
        height = 5,
        units = 'in',
        res = 150)

ggplot() +
  geom_sf(data = coast) +
  geom_sf(data = hc[hc$year %in% seq(1963, 2019, by = 5) &
                      hc$season == 'FALL',],
          aes(color = abundance)) +
  scale_color_viridis_c(name = 'Abundance',
                        trans = 'log10') +
  coord_sf(xlim = c(-76.5, -67), ylim = c(35, 43)) +
  labs(title = 'Horseshoe crab: Fall trawls') +
  facet_wrap(~ year)
dev.off()



agg_png('figures/horseshoecrab_springabundance_5yrly.png',
        width = 5,
        height = 5,
        units = 'in',
        res = 150)

ggplot() +
  geom_sf(data = coast) +
  geom_sf(data = hc[hc$year %in% seq(1963, 2019, by = 5) &
                      hc$season == 'SPRING',],
          aes(color = abundance)) +
  scale_color_viridis_c(name = 'Abundance',
                        trans = 'log10') +
  coord_sf(xlim = c(-76.5, -67), ylim = c(35, 43)) +
  labs(title = 'Horseshoe crab: Spring trawls') +
  facet_wrap(~ year)
dev.off()


agg_png('figures/horseshoecrab_fallabundance_5yrly_delmarva.png',
        width = 5,
        height = 5,
        units = 'in',
        res = 150)

ggplot() +
  geom_sf(data = coast) +
  geom_sf(data = hc[hc$year %in% seq(1963, 2019, by = 5) &
                      hc$season == 'FALL',],
          aes(color = abundance)) +
  scale_color_viridis_c(name = 'Abundance',
                        trans = 'log10') +
  coord_sf(xlim = c(-76.5, -72), ylim = c(37, 41)) +
  labs(title = 'Horseshoe crab: Fall trawls') +
  facet_wrap(~ year)
dev.off()


agg_png('figures/horseshoecrab_springabundance_5yrly_delmarva.png',
        width = 5,
        height = 5,
        units = 'in',
        res = 150)

ggplot() +
  geom_sf(data = coast) +
  geom_sf(data = hc[hc$year %in% seq(1963, 2019, by = 5) &
                      hc$season == 'SPRING',],
          aes(color = abundance)) +
  scale_color_viridis_c(name = 'Abundance',
                        trans = 'log10') +
  coord_sf(xlim = c(-76.5, -72), ylim = c(37, 41)) +
  labs(title = 'Horseshoe crab: Spring trawls') +
  facet_wrap(~ year)
dev.off()
