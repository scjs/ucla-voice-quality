---
output: 
  rmarkdown::html_vignette:
    keep_md: yes
---




```r
library("tabulizer")
library("tidyverse")
```

The word lists for each language are provided as PDF tables. Use 
`tabulizer::extract_tables()` to extract the tabular data in each PDF. Clean up 
the results as needed, then reshape the word lists into the tidyverse format.

For some of the word lists, `extract_tables()` can find all of the data
automatically. For others, an `area` argument is provided that contains the 
coordinates of the table on each page. When there is an `area` argument, the
coordinates were found using the interactive `tabulizer::locate_areas()`
function.

# Bo


```r
bo_tables <- extract_tables(
  file = "website/Bo/Bo_WordList.pdf",
  pages = c(1, 2),
  area = list(
    c(top = 64, left = 78, bottom = 717, right = 535),
    c(top = 73, left = 72, bottom = 574, right = 513)
  ),
  guess = FALSE
)
```


```r
style_names <- function (nm) {
  str_replace(tolower(nm), " ", "_")
}

bo_word_list <- map_dfr(bo_tables, as_tibble) %>%
  set_names(style_names(.[1, ])) %>%
  slice(-1)
```


```r
usethis::use_data(bo_word_list)

write_csv(bo_word_list, path = "csv/bo_word_list.csv")
```

# Gujarati

For the Gujarati word list, `extract_tables()` reads the column headers as if
they belonged to empty columns in between the real data columns.


```r
gujarati_tables <- extract_tables("website/Gujarati/Gujarati_WordList.pdf")
```


```r
gujarati_word_list <- map_dfr(gujarati_tables, as_tibble) %>%
  select(seq(2, 10, 2)) %>%
  set_names(style_names(gujarati_tables[[1]][2, seq(3, 11, 2)])) %>%
  filter(file_number != "")
```

Fix IPA `ɦ`, which should always be superscript. IPA `h` should only be
superscript when it is included in the target vowel.


```r
gujarati_word_list <-
  mutate(gujarati_word_list,
    target_vowel = str_replace_all(target_vowel, c("ɦ" = "ʱ", "h" = "ʰ")),
    target_pronunciation = ifelse(str_detect(target_vowel, "ʰ"),
      str_replace(target_pronunciation, "h", "ʰ"),
      str_replace(target_pronunciation, "ɦ", "ʱ")
      ),
    dictionary_pronunciation = ifelse(str_detect(target_vowel, "ʰ"),
      str_replace(dictionary_pronunciation, "h", "ʰ"),
      str_replace(dictionary_pronunciation, "ɦ", "ʱ")
      )
  )
```

Pad the file numbers with zeros for consistency with the filenames.


```r
gujarati_word_list <- mutate(gujarati_word_list,
  file_number = str_pad(file_number, width = 2, side = "left", pad = "0")
)
```


```r
usethis::use_data(gujarati_word_list)

write_csv(gujarati_word_list, path = "csv/gujarati_word_list.csv")
```

# Hmong


```r
hmong_tables <- extract_tables(
  file = "website/Hmong/Hmong_WordList.pdf",
  pages = seq(1, 4),
  area = list(
      c(top = 68, left = 53, bottom = 743, right = 530),
      c(top = 48, left = 69, bottom = 735, right = 546),
      c(top = 52, left = 78, bottom = 740, right = 561),
      c(top = 49, left = 77, bottom = 463, right = 436)
    ),
  guess = FALSE
)

hmong_colnames <- c("index", "orthography", "IPA", "gloss")
```

The White Hmong words are listed on the first page and part of the second
page. The Green Hmong words begin on the second page and continue through the
fourth page.

On all four pages, `extract_tables()` combines the index and orthography
columns into one column. On the second page, it also combines the IPA and gloss
columns into one column, so the second page needs to be reformatted before
it is combined with the other pages.

## White Hmong

For the White Hmong word list, `extract_tables()` reads the column headers on 
the first page as if they belonged to empty columns in between the real data
columns.


```r
page_one <- as_tibble(hmong_tables[[1]]) %>%
  slice(-1) %>%
  select(c(2, 4, 6)) %>%
  separate(V2, hmong_colnames[1:2]) %>%
  set_names(hmong_colnames)

page_two <- as_tibble(hmong_tables[[2]]) %>%
  extract(V1, hmong_colnames[1:2], "(\\d{1,2}) (.+)") %>%
  extract(V2, hmong_colnames[3:4], "(.+\\d) (.+)")

white_hmong_word_list <- bind_rows(page_one, page_two[1:29, ]) %>%
  mutate(language_variety = "White Hmong")
```

## Green Hmong

For the Green Hmong word list, some of the rows are read incorrectly on each
page, with parts of some cells moved to their own rows. Since there are only a
few of these, just remove the broken rows and re-type them out by hand.


```r
pages_three_four <- map_dfr(hmong_tables[3:4], as_tibble) %>%
  slice(c(1:54, 58:70, 74:76)) %>%
  extract(V1, hmong_colnames[1:2], "(\\d{1,2}) (.+)") %>%
  set_names(hmong_colnames)

broken_hmong_rows <- tribble(
  ~index, ~orthography, ~IPA, ~gloss,
  "12", "tug", "tu53", "plain; flat place; classifier for inanimates and long objects; to float",
  "15", "cug (cug haus qas)", "cu53", "treadmill; to collect in a vessel",
  "70", "puj (grandmother on father side / lady chicken)", "pu53", "female",
  "84", "kig (the word alone does not exist - most have a prefix)", "ki53", "morning (taag kig)",
  "88", "xuav paug / pus", "suɔ24 pau53 / suɔ24 pʌu53 / suɔ24 pu22", "thorn / cover"
)

green_hmong_word_list <- page_two[c(31:41, 45, 46), ] %>%
  bind_rows(pages_three_four) %>%
  bind_rows(broken_hmong_rows) %>%
  arrange(as.integer(index)) %>%
  mutate(language_variety = "Green Hmong")
```


```r
hmong_word_list <- bind_rows(white_hmong_word_list, green_hmong_word_list)
```


```r
usethis::use_data(hmong_word_list)

write_csv(hmong_word_list, path = "csv/hmong_word_list.csv")
```

# Luchun


```r
luchun_tables <- extract_tables(
  file = "website/Luchun/Luchun_WordList.pdf",
  pages = seq(1, 3),
  area = list(
    c(top = 88, left = 97, bottom = 721, right = 239),
    c(top = 67, left = 97, bottom = 716, right = 239),
    c(top = 73, left = 91, bottom = 499, right = 241)
  ),
  guess = FALSE
)
```


```r
luchun_word_list <- map_dfr(luchun_tables, as_tibble) %>%
  set_names(c("index", "transcription"))
```


```r
usethis::use_data(luchun_word_list)

write_csv(luchun_word_list, path = "csv/luchun_word_list.csv")
```

# Mazatec

The Mazatec word lists have an extra blank column at the end of the table,
and multi-line headers that get mangled. The 1984 word list begins on the second
page, and has one fewer column than the 1993 word list.


```r
mazatec_tables <- extract_tables("website/Mazatec/Mazatec_WordList.pdf")

mazatec_colnames <- c("filename", "IPA", "gloss", "orthography", "index")
```


```r
mazatec_1993_word_list <- map_dfr(mazatec_tables, as_tibble) %>%
  slice(4:56) %>%
  select(V1:V5) %>%
  set_names(mazatec_colnames) %>%
  mutate(recording_year = 1993L)
```


```r
mazatec_1984_word_list <- map_dfr(mazatec_tables, as_tibble) %>%
  slice(59:87) %>%
  select(V1:V4) %>%
  set_names(mazatec_colnames[-4]) %>%
  mutate(recording_year = 1984L)
```


```r
mazatec_word_list <- bind_rows(mazatec_1993_word_list, mazatec_1984_word_list)
```


```r
usethis::use_data(mazatec_word_list)

write_csv(mazatec_word_list, path = "csv/mazatec_word_list.csv")
```

# Miao

The Miao word lists include three different tables. The first table is three
pages wide, and includes minimal sets for five tones. The second table includes
other Miao words. The third table includes metadata for each audio file.

## Minimal sets


```r
ms_tables <- extract_tables(
  file = "website/Miao/Miao_WordList.pdf",
  pages = 1:3,
  area = list(
    c(top = 120, left = 30, bottom = 485, right = 600),
    c(top = 120, left = 30, bottom = 485, right = 600),
    c(top = 120, left = 30, bottom = 485, right = 600)
  ),
  guess = FALSE
)
```

The columns in this wide table come in pairs: the odd-numbered columns are the
IPA transcriptions for the words, and the even-numbered columns are their
English glosses. Each pair of columns has the data for one tone. In order, the
column pairs have data for tones: 44, 51, 55, 22, 45, 33, 13, 11.

On the third page, `extract_tables()` does not correctly identify the whitespace
as empty rows. Six empty rows need to be inserted so that the minimal sets will
be aligned correctly across the page-spanning rows.


```r
ms_tables[[3]] <- rbind(
  ms_tables[[3]][1:2, ],
  matrix(nrow = 1, ncol = 4),
  ms_tables[[3]][3, ],
  matrix(nrow = 1, ncol = 4),
  ms_tables[[3]][4:5, ],
  matrix(nrow = 1, ncol = 4),
  ms_tables[[3]][6:8, ],
  matrix(nrow = 1, ncol = 4),
  ms_tables[[3]][9:10, ],
  matrix(nrow = 2, ncol = 4)
)
```

Use `stats::reshape()` to gather multiple pairs of columns.


```r
# data.frame to avoid deprecated tibble rownames assigned in reshape()
miao_minimal_sets <- map_dfc(ms_tables, data.frame, stringsAsFactors = FALSE) %>%
  mutate_all(funs(na_if(., ""))) %>%
  reshape(
    varying = list(seq(1, 15, 2), seq(2, 16, 2)),
    v.names = c("IPA", "gloss"),
    idvar = "minimal_set_id",
    timevar = "tone",
    times = c("44", "51", "55", "22", "45", "33", "13", "11"),
    direction = "long"
    ) %>%
  drop_na(IPA) %>%
  arrange(minimal_set_id) %>%
  as_tibble()
```


```r
usethis::use_data(miao_minimal_sets)

write_csv(miao_minimal_sets, path = "csv/miao_minimal_sets.csv")
```

## Other words

In the table with other Miao words, the Tone column is read as empty. Sometimes
the values in the tone cells are ignored, and sometimes they are combined with
the Transcription column.


```r
ow_tables <- extract_tables(
  file = "website/Miao/Miao_WordList.pdf",
  pages = 4,
  area = list(c(top = 66, left = 45, bottom = 723, right = 294)),
  guess = FALSE
)
```


```r
miao_other_words <- as_tibble(ow_tables[[1]]) %>%
  select(c(2, 3)) %>%
  slice(-c(1, 2)) %>%
  set_names(c("IPA", "gloss")) %>%
  mutate(IPA = str_remove(IPA, "^\\d{1,2} ")) %>%
  extract(IPA, "tone", "(\\d{1,2})$", remove = FALSE) %>%
  replace_na(list(tone = "55"))
```


```r
usethis::use_data(miao_other_words)

write_csv(miao_other_words, path = "csv/miao_other_words.csv")
```

## Metadata for each filename


```r
fn_tables <- extract_tables(
  file = "website/Miao/Miao_WordList.pdf",
  pages = 5:45
)

fn_colnames <- c(
  "speaker", "code", "recording_number", "transcription", "segment", "filename"
)
```

The first five pages of the filename metadata table have four columns, not
including a recording number. These pages have the data for one speaker.


```r
liushilong <- map_dfr(fn_tables[1:5], as_tibble) %>%
  set_names(fn_colnames[-3]) %>%
  slice(-1)
```

The next 29 pages of the filename metadata table have four columns, not
including the segment. There are multiple rows with column headers. In some of
the rows, the transcription and filename are combined into the transcription
column.


```r
fn_body <- map_dfr(fn_tables[6:34], as_tibble) %>%
  set_names(fn_colnames[-5]) %>%
  filter(speaker != "Speaker") %>%
  # if a transcription cell has a space in it, it has both the transcription and
  # filename values
  # remove the filename and reconstruct the filename column
  mutate(transcription = str_remove(transcription, " .*")) %>%
  unite(filename, speaker, code, recording_number, remove = FALSE)
```

The last 11 pages have four columns, not including the segment or speaker code.
There are two rows with column headers. In some rows, the word and filename
columns are combined into one column. For others, the recording number and word
are combined into one column.


```r
fn_tail <- map_dfr(fn_tables[35:45], as_tibble) %>%
  set_names(fn_colnames[-c(2, 5)]) %>%
  filter(speaker != "Speaker") %>%
  separate(
    transcription, c("transcription", "filename"), sep = "  ?", fill = "right"
  ) %>%
  separate(
    recording_number, c("recording_number", "V5"), sep = "  ?", fill = "right"
  ) %>%
  mutate(transcription = coalesce(V5, transcription)) %>%
  select(-V5) %>%
  unite(filename, speaker, recording_number, remove = FALSE)
```


```r
miao_filename_list <- bind_rows(liushilong, fn_body, fn_tail)
```


```r
usethis::use_data(miao_filename_list)

write_csv(miao_filename_list, path = "csv/miao_filename_list.csv")
```

# Yi

The Yi word lists are available only as a screenshot of three tables embedded in 
a PDF. The original files with the text content no longer exist. The English and
IPA content was re-typed in tab-separated files in the tidyverse format.


```r
yi_tense_lax <- read_tsv(
  file = "yi/tense-lax.tsv",
  col_types = cols(.default = col_character())
)

usethis::use_data(yi_tense_lax)

write_csv(yi_tense_lax, path = "csv/yi_tense_lax.csv")
```


```r
yi_vowels <- read_tsv(
  file = "yi/vowels.tsv",
  col_types = cols(.default = col_character())
)

usethis::use_data(yi_vowels)

write_csv(yi_vowels, path = "csv/yi_vowels.csv")
```


```r
yi_tones <- read_tsv(
  file = "yi/tones.tsv",
  col_types = cols(.default = col_character())
)

usethis::use_data(yi_tones)

write_csv(yi_tones, path = "csv/yi_tones.csv")
```

# Zapotec

For the Zapotec word list, `extract_tables()` reads the column headers as if
they belonged to empty columns in between the real data columns. The word
indices are combined with the IPA column with inconsistent whitespace, and there
are multi-level headers that get mangled.

The tables also have square brackets that are not identified consistently, as
well as non-ASCII quotes. Breathy-voice and creaky-voice combining characters
are ignored in the conversion. If one of those characters combined with `u` or
`e`, both characters are ignored (always for `u`, but only sometimes for `e`).
Words with variant transcriptions (`bub ~ bob ~ bab`), parentheses, and glottal
stops are read with inconsistent whitespace.


```r
zapotec_tables <- extract_tables("website/Zapotec/Zapotec_WordList.pdf")
```


```r
zapotec_word_list <- map_dfr(zapotec_tables, as_tibble) %>%
  select(c(2, 4, 6)) %>%
  slice(-c(1, 2, 16, 34)) %>%
  extract(V2, c("index", "IPA"), "(\\d{1,2})\\.\\s*(.*)") %>%
  rename(english_gloss = V4, spanish_gloss = V6) %>%
  # strip non-ASCII quotes and square brackets
  mutate_all(funs(str_remove_all(., "[“”\\[\\]]"))) %>%
  # remove extra spaces after glottal stops and closing parentheses 
  mutate(IPA = str_replace_all(IPA, c("\\) " = "\\)", "ʔ " = "ʔ")))
```

Manually fix cells with missing `u`, `e`, or with variant transcriptions.


```r
zapotec_word_list[4, "IPA"] <- "bub ~ bob ~ bab"
zapotec_word_list[19, "IPA"] <- "da̤ ~ de̤"
zapotec_word_list[25, "IPA"] <- "ɾṳ ~ ɾo̤"
zapotec_word_list[27, "IPA"] <- "ʃṳn"
zapotec_word_list[28, "IPA"] <- "be̤ ~ bi̤"
zapotec_word_list[29, "IPA"] <- "kṳd"

zapotec_word_list[34, "IPA"] <- "dʒâ̰p"
zapotec_word_list[39, "IPA"] <- "bḛʔ"
zapotec_word_list[40, "IPA"] <- "bḛlː"
zapotec_word_list[42, "IPA"] <- "gṵn"
zapotec_word_list[43, "IPA"] <- "guʒa̰d ~ guʃa̰d"
zapotec_word_list[45, "IPA"] <- "bḛld"
```

In all of the remaining cases, extra whitespace in a transcription means that
the previous vowel should be combined with a breathy-voice diacritic (in
rows 14-30) or a creaky-voice diacritic (in rows 31-48).


```r
breathy_combinations <- c(
  "a " = "a̤",
  "e " = "e̤",
  "i " = "i̤",
  "o " = "o̤"
)

creaky_combinations <- c(
  "a " = "a̰",
  "e " = "ḛ",
  "i " = "ḭ",
  "o " = "o̰"
)
```


```r
zapotec_word_list <- mutate(zapotec_word_list,
  IPA = case_when(
    between(row_number(), 1, 13) ~ IPA,
    between(row_number(), 14, 30) ~ str_replace_all(IPA, breathy_combinations),
    between(row_number(), 31, 48) ~ str_replace_all(IPA, creaky_combinations)
  ),
  phonation = case_when(
    between(row_number(), 1, 13) ~ "Modal",
    between(row_number(), 14, 30) ~ "Breathy",
    between(row_number(), 31, 48) ~ "Creaky"
  )
)
```


```r
usethis::use_data(zapotec_word_list)

write_csv(zapotec_word_list, path = "csv/zapotec_word_list.csv")
```
