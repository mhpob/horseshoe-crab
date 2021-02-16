library(data.table)

hc <- fread('data/capture_recapture.csv',
            select = c('from', 'to', 'number'))

hc <- hc[from != 'unk' & to != 'unk']
hc[, c('from', 'to') := lapply(.SD, function(.){
  fcase(. == 'northeast', 'Northeast',
        . == 'ches bay', 'Ches.    ',
        . == 'coast ny-nj', 'Coastal NY-NJ',
        . == 'del bay', 'DE Bay',
        . == 'coast de-va', 'Coastal DE-VA',
        . == 'nc', 'NC',
        . == 'southeast', 'Southeast',
        . == 'gulf', 'Gulf')
}), .SDcols = c('from', 'to')]

arr.col <- hc[hc[from!=to, .I[which.max(number)], by = from]$V1]
arr.col[, ':='(number = NULL,
               col = 'black')]


library(circlize); library(ragg)


agg_png('figures/circle_plot.png',
        height = 3, width = 3, units = 'in', res = 300, scaling = 0.5)

circos.par(gap.after = 5)
chordDiagram(hc,
             order = c('Northeast',
                       'Coastal NY-NJ',
                       'DE Bay',
                       'Coastal DE-VA',
                       'Ches.    ',
                       'NC',
                       'Southeast',
                       'Gulf'),
             direction.type = 'diffHeight + arrows',
             link.arr.col = arr.col,
             directional = 1,
             diffHeight = 0.05)
circos.clear()

dev.off()
