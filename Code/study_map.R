library(ggplot2); library(sf)

survey_areas <- st_read('data derived/mapping/horseshoe_crab_survey_areas.shp') %>%
  dplyr::filter(!is.na(area))

lease_blocks <- st_read('data/mapping/boem_renewable_energy_areas.gdb',
                        layer = 'BOEM_Lease_Areas_4_13_2020',
                        query = "SELECT * FROM BOEM_Lease_Areas_4_13_2020 WHERE State = 'Maryland'")

coast <- st_read('data/mapping/coast_crop.shp') %>%
  st_transform(st_crs(lease_blocks)) %>%
  st_crop(xmin = -80, xmax = 70, ymin = 35, ymax = 40) %>%
  st_union %>%
  st_cast('POLYGON')



bathy <- st_read('data derived/mapping/bathy.gpkg',
                 query = 'select * from test where elev_m >= -50') %>%
  st_zm()


bsb_sites <- st_as_sf(data.frame(
  x = c(-74.7681, -74.75598),
  y = c(38.43075, 38.22359),
  site = c('Inner', 'Middle')
),
coords  = c('x', 'y'),
crs = 4326) %>%
  st_transform(st_crs(lease_blocks))


library(ggspatial); library(ragg)

agg_png('figures/study_map.png', height = 650, width = 850, scaling = 1.5)

ggplot() +
  geom_sf(data = coast, fill = 'gray') +

  geom_sf(data = survey_areas, aes(fill = area), size = 5, alpha = 0.5) +
  geom_sf(data = bathy, aes(color = as.factor(elev_m))) +

  geom_sf(data = lease_blocks, fill = NA, color = 'darkgray', size = 1) +

  geom_sf(data = bsb_sites, shape = 15, size = 3) +

  annotation_scale(location = 'tl') +
  coord_sf(xlim  = c(-75.2, -74.2), ylim = c(38, 38.6)) +

  scale_color_viridis_d() +
  labs(fill = 'Experimental Area', color = 'Depth (m)') +
  theme_bw() +

  theme(legend.position = c(0.8, 0.7),
        legend.box.background = element_rect(fill = 'white', color = 'black'),
        legend.background = element_rect(fill = NA),
        plot.margin = margin(0, 0, 0, 0))


dev.off()
