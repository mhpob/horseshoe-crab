library(data.table)

hc <- fread('data/capture_recapture.csv',
            select = c('from', 'to', 'number'))

hc[, c('from', 'to') := lapply(.SD, function(.){
  fcase(. == 'northeast', 'Northeast',
        . == 'ches bay', 'Ches.    ',
        . == 'coast ny-nj', 'Coastal NY-NJ',
        . == 'del bay', 'DE Bay',
        . == 'coast de-va', 'Coastal DE-VA',
        . == 'nc', 'NC',
        . == 'southeast', 'Southeast',
        . == 'gulf', 'Gulf',
        . == 'unk', 'Unknown')
}), .SDcols = c('from', 'to')]

library(circlize); library(ragg)


agg_png('figures/circle_plot.png',
        height = 3, width = 3, units = 'in', res = 300, scaling = 0.5)

circos.par(gap.after = 5)
chordDiagram(hc[from != 'Unknown' &
                  to != 'Unknown'],
             order = c('Northeast',
                       'Coastal NY-NJ',
                       'DE Bay',
                       'Coastal DE-VA',
                       'Ches.    ',
                       'NC',
                       'Southeast',
                       'Gulf'),
             direction.type = 'diffHeight + arrows',
             link.arr.lwd = 0.1,
             big.gap = 1000,
             directional = -1,
             diffHeight = 0.05)
circos.clear()

dev.off()
