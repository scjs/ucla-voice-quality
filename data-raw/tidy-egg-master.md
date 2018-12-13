---
output: 
  rmarkdown::html_vignette:
    keep_md: yes
---




```r
library("openxlsx")
library("tidyverse")
```

The EGG master spreadsheet can be downloaded from the
[project website](http://www.phonetics.ucla.edu/voiceproject/voice.html).

Rows 4756-5151 (4757-5152 with header) have misaligned data for some of the
columns. The values in the column `peak_Vel_Time_means009` are duplicated such
that they appear both under the correct header and under the next column header
`min_Vel_mean`. For these rows only, the values in the column `min_Vel_means001`
and all columns to its right need to be moved one column to the left.

First, read in the spreadsheet with the affected rows omitted.


```r
egg <- read.xlsx("website/Spreadsheet/Voice_EGG.xlsx",
  rows = c(1:4756, 5153:14807),
  na.strings = c("", "NA", "nan", "new")
)

glimpse(egg)
#> Observations: 14,410
#> Variables: 133
#> $ Filename               <chr> "F1_Xe=31_01.mat", "F1_Xe=31_01.mat", "...
#> $ Label                  <chr> "X", "e=31", "X", "e=31", "X", "e=_31",...
#> $ Language               <chr> "Bo", "Bo", "Bo", "Bo", "Bo", "Bo", "Bo...
#> $ `Dialect/Village`      <chr> "v1", "v1", "v1", "v1", "v1", "v1", "v1...
#> $ Sex                    <chr> "F", "F", "F", "F", "F", "F", "F", "F",...
#> $ `Speaker.#`            <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
#> $ Speaker                <chr> "F1", "F1", "F1", "F1", "F1", "F1", "F1...
#> $ Lang_Spk               <chr> "Bo_F1", "Bo_F1", "Bo_F1", "Bo_F1", "Bo...
#> $ Phonation              <chr> "L", "L", "L", "L", "T", "T", "T", "T",...
#> $ Lphon                  <chr> "BL", "BL", "BL", "BL", "BT", "BT", "BT...
#> $ Vowel                  <chr> NA, "e=", NA, "e=", NA, "e=", NA, "e=",...
#> $ `Oral/Nasal`           <chr> "C", "O", "C", "O", "C", "O", "C", "O",...
#> $ Tone.From.txtgrid      <chr> "31", "31", "31", "31", "31", "31", "31...
#> $ Tone.Cont              <dbl> 31, 31, 31, 31, 31, 31, 31, 31, 33, 33,...
#> $ Tone.Cat               <chr> "M", "M", "M", "M", "M", "M", "M", "M",...
#> $ No..Tone               <dbl> 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 2, ...
#> $ Tone                   <chr> "low", "low", "low", "low", "low", "low...
#> $ Tphon                  <chr> "fall_L", "fall_L", "fall_L", "fall_L",...
#> $ CorV                   <chr> "C", "V", "C", "V", "C", "V", "C", "V",...
#> $ Aspiration             <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ...
#> $ Duration               <dbl> 189.080, 282.618, 137.290, 553.754, 220...
#> $ seg_Start              <dbl> 456.685, 645.765, 230.498, 367.788, 118...
#> $ seg_End                <dbl> 645.765, 928.383, 367.788, 921.542, 339...
#> $ CQ_mean                <chr> "0.45500000000000002", "0.5729999999999...
#> $ CQ_means001            <chr> "0.499", "0.51400000000000001", "0.3639...
#> $ CQ_means002            <chr> "0.43", "0.56699999999999995", "0.623",...
#> $ CQ_means003            <chr> "0.45700000000000002", "0.5360000000000...
#> $ CQ_means004            <chr> "0.441", "0.55000000000000004", "0.5590...
#> $ CQ_means005            <chr> "0.42699999999999999", "0.5969999999999...
#> $ CQ_means006            <chr> "0.45100000000000001", "0.6029999999999...
#> $ CQ_means007            <chr> "0.48699999999999999", "0.6129999999999...
#> $ CQ_means008            <chr> "0.46600000000000003", "0.5719999999999...
#> $ CQ_means009            <chr> "0.46899999999999997", "0.6770000000000...
#> $ CQ_H_mean              <chr> "0.4", "0.504", "0.39600000000000002", ...
#> $ CQ_H_means001          <chr> "0.41299999999999998", "0.48", "0.28299...
#> $ CQ_H_means002          <chr> "0.38100000000000001", "0.502", "0.6", ...
#> $ CQ_H_means003          <chr> "0.4", "0.47699999999999998", "0.43", "...
#> $ CQ_H_means004          <chr> "0.379", "0.496", "0.39900000000000002"...
#> $ CQ_H_means005          <chr> "0.38400000000000001", "0.5130000000000...
#> $ CQ_H_means006          <chr> "0.40600000000000003", "0.5320000000000...
#> $ CQ_H_means007          <chr> "0.437", "0.53600000000000003", "0.3330...
#> $ CQ_H_means008          <chr> "0.40699999999999997", "0.4739999999999...
#> $ CQ_H_means009          <chr> "0.40300000000000002", "0.5779999999999...
#> $ CQ_PM_mean             <chr> "0.26700000000000002", "0.4119999999999...
#> $ CQ_PM_means001         <chr> "0.22500000000000001", "0.3290000000000...
#> $ CQ_PM_means002         <chr> "0.23599999999999999", "0.47", "0.47699...
#> $ CQ_PM_means003         <chr> "0.19400000000000001", "0.4189999999999...
#> $ CQ_PM_means004         <chr> "0.23699999999999999", "0.4129999999999...
#> $ CQ_PM_means005         <chr> "0.27600000000000002", "0.436", "0.2419...
#> $ CQ_PM_means006         <chr> "0.31900000000000001", "0.438", "0.2079...
#> $ CQ_PM_means007         <chr> "0.29499999999999998", "0.4149999999999...
#> $ CQ_PM_means008         <chr> "0.28699999999999998", "0.375", "0.151"...
#> $ CQ_PM_means009         <chr> "0.30299999999999999", "0.41", "0.28799...
#> $ CQ_HT_mean             <chr> "0.52300000000000002", "0.5979999999999...
#> $ CQ_HT_means001         <chr> "0.69199999999999995", "0.5320000000000...
#> $ CQ_HT_means002         <chr> "0.47", "0.624", "0.67700000000000005",...
#> $ CQ_HT_means003         <chr> "0.56599999999999995", "0.5969999999999...
#> $ CQ_HT_means004         <chr> "0.47799999999999998", "0.5869999999999...
#> $ CQ_HT_means005         <chr> "0.55600000000000005", "0.6360000000000...
#> $ CQ_HT_means006         <chr> "0.53800000000000003", "0.6879999999999...
#> $ CQ_HT_means007         <chr> "0.44700000000000001", "0.6059999999999...
#> $ CQ_HT_means008         <chr> "0.42199999999999999", "0.505", "0.3489...
#> $ CQ_HT_means009         <chr> "0.65700000000000003", "0.621", "0.4769...
#> $ peak_Vel_mean          <chr> "562.11199999999997", "500.279", "537.4...
#> $ peak_Vel_means001      <chr> "483.79700000000003", "524.075000000000...
#> $ peak_Vel_means002      <chr> "506.29500000000002", "573.552000000000...
#> $ peak_Vel_means003      <chr> "543.86199999999997", "566.645999999999...
#> $ peak_Vel_means004      <chr> "561.83900000000006", "573.952999999999...
#> $ peak_Vel_means005      <chr> "618.22199999999998", "555.494000000000...
#> $ peak_Vel_means006      <chr> "600.54200000000003", "530.327999999999...
#> $ peak_Vel_means007      <chr> "602.19100000000003", "466.184000000000...
#> $ peak_Vel_means008      <chr> "550.226", "281.911", "528.879000000000...
#> $ peak_Vel_means009      <chr> "536.09299999999996", "245.304", "556.8...
#> $ peak_Vel_Time_mean     <chr> "557.34199999999998", "774.154", "300.5...
#> $ peak_Vel_Time_means001 <chr> "473.06099999999998", "660.264999999999...
#> $ peak_Vel_Time_means002 <chr> "486.947", "691.81799999999998", "251.6...
#> $ peak_Vel_Time_means003 <chr> "507.995", "723.18600000000004", "265.6...
#> $ peak_Vel_Time_means004 <chr> "528.72699999999998", "754.41", "283.83...
#> $ peak_Vel_Time_means005 <chr> "549.39200000000005", "785.144999999999...
#> $ peak_Vel_Time_means006 <chr> "570.97699999999998", "816.633000000000...
#> $ peak_Vel_Time_means007 <chr> "592.11099999999999", "848.229000000000...
#> $ peak_Vel_Time_means008 <chr> "612.77200000000005", "880.057000000000...
#> $ peak_Vel_Time_means009 <chr> "633.89300000000003", "899.621999999999...
#> $ min_Vel_mean           <dbl> -211.100, -181.312, -227.428, -185.328,...
#> $ min_Vel_means001       <dbl> -213.550, -195.213, -185.901, -216.614,...
#> $ min_Vel_means002       <dbl> -187.613, -209.127, -215.586, -216.662,...
#> $ min_Vel_means003       <dbl> -211.875, -206.534, -223.276, -163.759,...
#> $ min_Vel_means004       <dbl> -207.356, -229.389, -231.693, -137.898,...
#> $ min_Vel_means005       <dbl> -228.984, -196.678, -230.091, 0.000, -2...
#> $ min_Vel_means006       <dbl> -231.727, -169.184, -234.793, 0.000, -2...
#> $ min_Vel_means007       <dbl> -217.190, -139.233, -256.521, 0.000, -2...
#> $ min_Vel_means008       <dbl> -206.040, -122.072, -246.210, 0.000, -2...
#> $ min_Vel_means009       <dbl> -197.313, -117.445, -206.466, 0.000, -2...
#> $ min_Vel_Time_mean      <dbl> 558.562, 776.150, 302.454, 486.926, 237...
#> $ min_Vel_Time_means001  <dbl> 474.044, 661.685, 239.808, 398.548, 140...
#> $ min_Vel_Time_means002  <dbl> 487.988, 693.920, 256.845, 460.749, 155...
#> $ min_Vel_Time_means003  <dbl> 508.869, 725.112, 269.330, 522.037, 180...
#> $ min_Vel_Time_means004  <dbl> 529.805, 756.378, 284.840, 579.366, 204...
#> $ min_Vel_Time_means005  <dbl> 550.658, 787.318, 298.818, 0.000, 229.0...
#> $ min_Vel_Time_means006  <dbl> 572.459, 818.866, 314.294, 0.000, 253.5...
#> $ min_Vel_Time_means007  <dbl> 593.476, 850.295, 330.525, 0.000, 278.3...
#> $ min_Vel_Time_means008  <dbl> 614.087, 882.123, 343.471, 0.000, 303.4...
#> $ min_Vel_Time_means009  <dbl> 635.301, 901.728, 361.345, 0.000, 327.5...
#> $ `SQ2-SQ1_mean`         <dbl> 0.508, 0.791, 1.291, 0.655, 0.777, 0.76...
#> $ `SQ2-SQ1_means001`     <dbl> 0.302, 0.451, 0.912, 0.511, 1.672, 0.48...
#> $ `SQ2-SQ1_means002`     <dbl> 0.326, 0.671, 0.760, 0.761, 1.017, 0.78...
#> $ `SQ2-SQ1_means003`     <dbl> 0.486, 0.821, 1.010, 0.507, 0.838, 0.81...
#> $ `SQ2-SQ1_means004`     <dbl> 0.443, 0.765, 2.842, 0.877, 0.756, 0.85...
#> $ `SQ2-SQ1_means005`     <dbl> 0.438, 0.791, 1.013, 0.000, 0.816, 0.94...
#> $ `SQ2-SQ1_means006`     <dbl> 0.788, 0.547, 0.836, 0.000, 0.709, 0.87...
#> $ `SQ2-SQ1_means007`     <dbl> 0.732, 0.496, 0.780, 0.000, 0.649, 0.46...
#> $ `SQ2-SQ1_means008`     <dbl> 0.516, 1.769, 0.593, 0.000, 0.631, 0.63...
#> $ `SQ2-SQ1_means009`     <dbl> 0.391, 0.922, 2.788, 0.000, 0.505, 1.15...
#> $ `SQ4-SQ3_mean`         <dbl> -0.236, -0.837, -1.254, -0.470, -0.436,...
#> $ `SQ4-SQ3_means001`     <dbl> 1.723, 0.084, 2.731, 0.431, -1.156, 0.6...
#> $ `SQ4-SQ3_means002`     <dbl> 0.540, -0.114, -5.045, -0.368, -1.185, ...
#> $ `SQ4-SQ3_means003`     <dbl> -1.149, -2.257, -4.541, 0.754, 0.744, -...
#> $ `SQ4-SQ3_means004`     <dbl> 0.313, 0.472, 1.542, -3.074, -1.117, 0....
#> $ `SQ4-SQ3_means005`     <dbl> -0.197, 0.212, -0.172, 0.000, -0.218, 0...
#> $ `SQ4-SQ3_means006`     <dbl> -1.114, -1.169, -2.775, 0.000, 0.601, 1...
#> $ `SQ4-SQ3_means007`     <dbl> 0.471, -2.607, -0.275, 0.000, 1.007, 2....
#> $ `SQ4-SQ3_means008`     <dbl> 0.499, -0.521, 0.260, 0.000, -2.587, -0...
#> $ `SQ4-SQ3_means009`     <dbl> -1.812, -3.779, -1.061, 0.000, -0.520, ...
#> $ ratio_mean             <dbl> 0.152, 0.231, 0.560, 0.184, 0.227, 0.19...
#> $ ratio_means001         <dbl> 0.193, 0.126, 0.324, 0.177, 0.104, 0.14...
#> $ ratio_means002         <dbl> 0.094, 0.222, 0.087, 0.228, 0.359, 0.01...
#> $ ratio_means003         <dbl> 0.135, 0.024, 0.178, 0.144, 0.403, 0.19...
#> $ ratio_means004         <dbl> 0.129, 0.304, 1.614, 0.186, 0.209, 0.22...
#> $ ratio_means005         <dbl> 0.125, 0.147, 0.277, 0.000, 0.155, 0.25...
#> $ ratio_means006         <dbl> 0.111, 0.092, 0.016, 0.000, 0.290, 0.29...
#> $ ratio_means007         <dbl> 0.285, 0.089, 0.131, 0.000, 0.269, 0.09...
#> $ ratio_means008         <dbl> 0.232, 0.757, 0.337, 0.000, 0.036, 0.08...
#> $ ratio_means009         <dbl> 0.095, 0.537, 2.047, 0.000, 0.134, 0.59...
```

Some of these cells have numbers formatted like `1.6E-2` which are read as type
`character` by `read.xlsx()`. To fix these, lowercase them and then coerce them
to type `double`.


```r
egg <- egg %>%
  mutate_at(vars(CQ_mean:peak_Vel_Time_means009), tolower) %>%
  mutate_at(vars(CQ_mean:peak_Vel_Time_means009), as.double)
```

Next, read in only the affected rows.


```r
misaligned <- read.xlsx("website/Spreadsheet/Voice_EGG.xlsx",
  rows = c(4757:5152),
  colNames = FALSE,
  skipEmptyCols = FALSE
)
```

Convert the affected rows to a list of columns, and use `duplicated()` to show
the duplicated column (column 84), then remove it. Columns 13-18 also show as
duplicated, but that's only because those are metadata that does not vary for
this subset of the data.


```r
duplicated(as.list(misaligned))
#>   [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [12] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE
#>  [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [34] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [56] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [67] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [78] FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE
#>  [89] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [100] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [111] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [122] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [133] FALSE FALSE

misaligned <- select(misaligned, -84)

duplicated(as.list(misaligned))
#>   [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [12] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE
#>  [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [34] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [56] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [67] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [78] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [89] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [100] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [111] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [122] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [133] FALSE
```

Give the misaligned data the correct column names, and combine it with the rest
of the table.


```r
colnames(misaligned) <- colnames(egg)

egg <- bind_rows(egg, misaligned)
```

The tone number, aspiration, tone contour, and speaker number columns were read
as type `double`. Coerce these columns to the correct types.


```r
egg <- mutate(egg,
  No..Tone = as.integer(No..Tone),
  Aspiration = as.logical(Aspiration),
  Tone.Cont = as.character(Tone.Cont),
  `Speaker.#` = as.character(`Speaker.#`)
)
```

Discard the overall mean columns, which won't be used when the dataframe is in
the tidyverse format.


```r
egg <- select(egg, -ends_with("mean"))
```

The EGG master spreadsheet has both a `Tone` and a `Tone.Cat` column. The
`Tone.Cat` column is not documented in the readme, but it has codes for H(igh),
M(edium), L(ow), and B(ig), which are the four categories that the readme says
should be in the `Tone` column. The `Tone` column here has 11 different codes
that don't map onto these tone categories, the contours, or the 
language-specific conventions (`Tone.From.txtgrid`).


```r
count(egg,
  Tone.Cat, Tone.Cont, Tone.From.txtgrid, Tone, Language, `Dialect/Village`) %>% 
  print(n = 45)
#> # A tibble: 45 x 7
#>    Tone.Cat Tone.Cont Tone.From.txtgr… Tone  Language `Dialect/Villag…
#>    <chr>    <chr>     <chr>            <chr> <chr>    <chr>           
#>  1 <NA>     <NA>      <NA>             <NA>  Gujarati <NA>            
#>  2 B        51        <NA>             Lfall Zapotec  SJG             
#>  3 B        51        <NA>             Lfall Zapotec  SMZ             
#>  4 B        51        4                fall  Mandarin <NA>            
#>  5 B        51        51               Big   Miao     Black           
#>  6 H        44        44               High  Miao     Black           
#>  7 H        45        45               High  Miao     Black           
#>  8 H        45        b                high  Hmong    W               
#>  9 H        53        53               high  Bo       v2              
#> 10 H        53        53               low   Bo       v1              
#> 11 H        53        g                high  Hmong    W               
#> 12 H        53        j                high  Hmong    W               
#> 13 H        55        <NA>             high  Zapotec  SJG             
#> 14 H        55        <NA>             high  Zapotec  SMZ             
#> 15 H        55        1                high  Mandarin <NA>            
#> 16 H        55        55               high  Bo       v1              
#> 17 H        55        55               high  Bo       v2              
#> 18 H        55        55               high  Luchun   <NA>            
#> 19 H        55        55               high  Yi       v1              
#> 20 H        55        55               High  Miao     Black           
#> 21 L        11        11               Low   Miao     Black           
#> 22 L        13        13               Low   Miao     Black           
#> 23 L        13        13               rise  Bo       v1              
#> 24 L        21        21               low   Bo       v2              
#> 25 L        21        21               low   Yi       v1              
#> 26 L        21        21               low   Yi       v2              
#> 27 L        21        m                low   Hmong    W               
#> 28 L        213       3                low   Mandarin <NA>            
#> 29 L        214       d                low   Hmong    W               
#> 30 L        22        22               Mid   Miao     Black           
#> 31 L        22        s                low   Hmong    W               
#> 32 M        24        2                rise  Mandarin <NA>            
#> 33 M        24        v                mid   Hmong    W               
#> 34 M        31        <NA>             Sfall Zapotec  SJG             
#> 35 M        31        <NA>             Sfall Zapotec  SMZ             
#> 36 M        31        31               low   Bo       v1              
#> 37 M        31        31               low   Bo       v2              
#> 38 M        31        31               low   Luchun   <NA>            
#> 39 M        33        33               mid   Bo       v1              
#> 40 M        33        33               mid   Bo       v2              
#> 41 M        33        33               mid   Luchun   <NA>            
#> 42 M        33        33               mid   Yi       v1              
#> 43 M        33        33               mid   Yi       v2              
#> 44 M        33        33               Mid   Miao     Black           
#> 45 M        33        x                mid   Hmong    W               
#> # ... with 1 more variable: n <int>
```

For instance, an `H` code in `Tone.Cat` with a `53` in `Tone.Cont` has rows
that are coded both as `high` and `low` in the `Tone` column. These are in
different villages, though. Until this is clarified, rename this column to
`tone_misc`.


```r
egg <- rename(egg, tone_misc = Tone)
```

Remove the `.mat` extension from the filenames.


```r
egg <- mutate(egg, Filename = str_remove(Filename, "\\.mat$"))
```

Rename and recode some columns with the descriptive names from the PDF readme.


```r
egg <- mutate(egg,
  language_variety = recode(`Dialect/Village`,
    Black = "Black Miao",
    CH = "China",
    TW = "Taiwan",
    SJG = "San Juan Guelavia Zapotec",
    SMZ = "Santiago Matatlan Zapotec",
    v1 = "Village 1",
    v2 = "Village 2",
    W = "White Hmong"
  ),
  phonation = recode(Phonation,
    M = "Modal",
    C = "Creaky",
    B = "Breathy",
    L = "Lax",
    `T` = "Tense"
  ),
  vowel_nasality = recode(`Oral/Nasal`,
    O = "Oral",
    N = "Nasal"
  ),
  tone_category = recode(Tone.Cat,
    H = "High",
    M = "Mid",
    L = "Low",
    B = "Big"
  ),
  segment_type = recode(CorV,
    C = "Consonant",
    V = "Vowel"
  ),
  consonant_aspiration = ifelse(Aspiration,
    "Aspirated",
    "Unaspirated"
  )
)

egg <- select(egg,
  -`Dialect/Village`,
  -Phonation,
  -`Oral/Nasal`,
  -Tone.Cat,
  -CorV,
  -Aspiration
)
```

Remove columns that don't provide any unique information.


```r
egg <- select(egg,
  -Speaker, # composite of Sex + Speaker_Number columns
  -Lphon,   # composite of Language + Phonation columns
  -Tphon    # composite of Tone.Cat + Phonation columns
)
```

Rename the columns in the tidyverse style.


```r
egg <- rename(egg,
  textgrid_label = Label,
  speaker_number = `Speaker.#`,
  speaker_id = Lang_Spk,
  speaker_sex = Sex,
  tone_contour = Tone.Cont,
  number_of_tone_targets = No..Tone,
  language_specific_tone = Tone.From.txtgrid,
  vowel_quality = Vowel
)

egg <- rename_all(egg, funs(str_replace(., "-", "_")))

# lowercase, but avoid lowercasing the measurement columns, eg CQ
egg <- rename_if(egg, funs(!is_double(.)), tolower) %>%
  rename(segment_end = seg_End, segment_start = seg_Start, duration = Duration)
```

Reshape the dataframe. Columns ending in 001-009 are timepoints.


```r
egg <- egg %>%
  gather(key, value, matches("00\\d$")) %>%
  extract(key, c("measure", "timepoint"), "(.+?)_means00(\\d)") %>%
  spread(measure, value) %>%
  mutate(timepoint = as.integer(timepoint))
```

Rearrange the columns:

1. Information about the speaker and their language
2. Name of the audio file and the timestamps in the file where this segment
comes from
3. Information about the segment and preceding consonant, as applicable
5. EGG measures


```r
egg <- select(egg,
  speaker_id, speaker_number, speaker_sex, language, language_variety,
  filename, segment_start, segment_end, duration, timepoint,
  textgrid_label, segment_type, vowel_quality, phonation, vowel_nasality,
  consonant_aspiration,
  tone_contour, number_of_tone_targets, tone_category, language_specific_tone,
  tone_misc,
  CQ, CQ_H, CQ_HT, CQ_PM,
  min_Vel, min_Vel_Time, peak_Vel, peak_Vel_Time,
  SQ2_SQ1, SQ4_SQ3, ratio
) %>%
  arrange(filename, segment_start, timepoint)
```

In the reshaped table, individual measures with bad data at a particular
timepoint are marked with a `0` placeholder instead of a measurement value.
Change these to `NA`.


```r
egg <- mutate_at(egg, vars(CQ:ratio), funs(na_if(., 0)))
```

Save the data.


```r
usethis::use_data(egg)

write_csv(egg, path = "csv/egg.csv")
```
