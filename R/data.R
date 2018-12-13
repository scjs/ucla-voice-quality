#' Acoustic measurements for the UCLA voice quality project
#'
#' Acoustic measurements from recordings of Bo, English, Gujarati, Hmong,
#' Luchun, Mandarin, Mazatec, Miao, Yi, and Zapotec. Measurements are taken at
#' nine timepoints within each phonetic segment (vowel or consonant), including
#' the pitch, formant filter, harmonic amplitudes, energy, and noise.
#'
#' This documentation is based on the the spreadsheet key on the
#' \href{http://www.phonetics.ucla.edu/voiceproject/voice.html}{UCLA project website}.
#' Please see that page for more information about the corpus (including the
#' original audio recordings) and for citation and licensing instructions. For
#' more information on the acoustic measures, see the
#' \href{http://www.seas.ucla.edu/spapl/voicesauce/}{VoiceSauce documentation}.
#'
#' This table is a version of the original acoustic master spreadsheet converted
#' to the
#' \href{https://r4ds.had.co.nz/tidy-data.html}{tidy data format} for use with
#' the tidyverse R packages. It has one row per timepoint, rather than one row
#' per filename, and one column per acoustic measure, rather than nine timepoint
#' columns and one overall mean for each measure. Each phonetic segment in the
#' data has a unique combination of \code{filename} and \code{segment_start}
#' values, and each measurement has a unique combination of \code{filename},
#' \code{segment_start}, and \code{timepoint} values.
#'
#' The original spreadsheet had a column to indicate bad data in some cells. In
#' this version, all of these values have been replaced with NA, and the bad
#' data column has been removed. The authors also recommend further exclusions,
#' described on the second page of the original spreadsheet:
#'
#' 1. Exclude data where the STRAIGHT f0 measurement (\code{strF0}) differs from
#'  the Praat f0 measurement (\code{pF0}) by more than 200 Hz. See first example
#'  below.
#'
#' 2. Exclude all data from any file where the mean of the middle three Snack
#' F1 measurements (\code{sF1}) differs from the mean of the middle three Praat
#' F1 measurements (\code{pF1}) by more than 200 Hz. See second example below.
#'
#' @examples
#' data("acoustics", package = "voicequality")
#'
#' # First suggested exclusion, when using measures that depend on pitch tracking
#' filter(acoustics, abs(strF0 - pF0) <= 200)
#'
#' # Second suggested exclusion, when using measures that depend on formant estimates
#' filenames_to_include <- acoustics %>%
#'   filter(between(timepoint, 4, 6)) %>%
#'   group_by(filename, segment_start) %>%
#'   summarize(diff_F1 = abs(mean(sF1) - mean(pF1))) %>%
#'   filter(diff_F1 <= 200) %>%
#'   pull(filename)
#'
#' filter(acoustics, filename %in% unique(filenames_to_include))
#'
#' @format A data frame with 151,488 rows and 66 variables:
#' \describe{
#'   \item{speaker_id}{Speaker ID. Unique across all eight languages.}
#'   \item{speaker_number}{Speaker number or pseudonym. Unique within a language
#'   but not across languages.}
#'   \item{speaker_sex}{F for female or M for male.}
#'   \item{language}{Language that this word is from.}
#'   \item{language_variety}{Dialect of the language, or the location where this
#'   word was recorded.}
#'   \item{filename}{Filename of the corresponding audio file. For a description
#'   of file naming conventions, see the PDF notes for each language on the
#'   project website.}
#'   \item{segment_start}{Start time of this phonetic segment in the audio file,
#'   in milliseconds.}
#'   \item{segment_end}{End time of this phonetic segment in the audio file, in
#'   milliseconds.}
#'   \item{duration}{Duration of this segment, in milliseconds.}
#'   \item{timepoint}{Time within the segment where these measurements were
#'   taken, as a number from 1 to 9. A 1 means that this row has measurements
#'   taken during the first ninth of the segment, a 2 means that it has
#'   measurements taken during the second ninth, etc.}
#'   \item{textgrid_label}{Segment label in the corresponding Praat TextGrid.
#'   See the PDF notes for each language on the project website for IPA
#'   equivalents.}
#'   \item{segment_type}{Whether the segment is a vowel or a consonant.}
#'   \item{vowel_quality}{Vowel quality for this segment. NA if these
#'   measurements are from a consonant.}
#'   \item{phonation}{Phonation type of the segment.}
#'   \item{vowel_nasality}{Whether the vowel is oral or nasal.}
#'   \item{tone_contour}{Sequence of tone targets for this tone type, using the
#'   standard IPA range with the numbers 1-5, where 1 is low, 3 is mid, and 5 is
#'   high. NA for languages without lexical tone.}
#'   \item{number_of_tone_targets}{Number of tone targets for this tone type,
#'   from 1 to 3.}
#'   \item{tone_category}{Label for tone contour, divided into four categories:
#'   high (55, 53, 45, 44, 535), mid (24, 33, 35, 31), low (22, 21, 11, 213,
#'   13), and big (51, 351, 15, 151, 153).}
#'   \item{language_specific_tone}{Tone label based on language-specific
#'   tone transcription conventions, which were also used to annotate tone in
#'   the original TextGrid file. For example, in Mandarin Chinese, the
#'   files were annotated with the traditional labels of Tone 1, 2, 3 or 4.
#'   The \code{tone_contour} and \code{tone_category} columns have the actual
#'   tone contours for each tone type.}
#'   \item{consonant_aspiration}{Whether the consonant preceding the vowel is
#'   aspirated or unaspirated. If this segment is a consonant, then whether this
#'   segment is aspirated or unaspirated.}
#'   \item{consonant_nasality}{Whether the consonant preceding the
#'   vowel is oral or nasal. NA if these measurements are from a
#'   consonant.}
#'   \item{strF0}{Fundamental frequency of the voice, in Hz, as measured by
#'   STRAIGHT (Kawahara et al., 1998).}
#'   \item{sF0}{Fundamental frequency of the voice, in Hz, as measured by
#'   Snack.}
#'   \item{pF0}{Fundamental frequency of the voice, in Hz, as measured by
#'   Praat.}
#'   \item{shrF0}{Fundamental frequency of the voice, in Hz, as measured using
#'   the subharmonic-to-harmonic ratio method (Sun 2002).}
#'   \item{sF1}{Frequency of the first formant, in Hz, as measured by Snack.}
#'   \item{sB1}{Bandwidth of the first formant, in Hz, as measured by Snack.}
#'   \item{sF2}{Frequency of the second formant, in Hz, as measured by Snack.}
#'   \item{sB2}{Bandwidth of the second formant, in Hz, as measured by Snack.}
#'   \item{sF3}{Frequency of the third formant, in Hz, as measured by Snack.}
#'   \item{sB3}{Bandwidth of the third formant, in Hz, as measured by Snack.}
#'   \item{sF4}{Frequency of the fourth formant, in Hz, as measured by Snack.}
#'   \item{sB4}{Bandwidth of the fourth formant, in Hz, as measured by Snack.}
#'   \item{pF1}{Frequency of the first formant, in Hz, as measured by Praat.}
#'   \item{pF2}{Frequency of the second formant, in Hz, as measured by Praat.}
#'   \item{pF3}{Frequency of the third formant, in Hz, as measured by Praat.}
#'   \item{pF4}{Frequency of the fourth formant, in Hz, as measured by Praat.}
#'   \item{H1u}{Amplitude of the first harmonic of the voice.}
#'   \item{H1c}{Amplitude of the first harmonic of the voice. Corrected for the
#'   formant filter based on Iseli & Alwan (2004, 2006, 2007).}
#'   \item{H2u}{Amplitude of the second harmonic of the voice.}
#'   \item{H2c}{Amplitude of the second harmonic of the voice. Corrected for the
#'   formant filter.}
#'   \item{H4u}{Amplitude of the third harmonic of the voice.}
#'   \item{H4c}{Amplitude of the fourth harmonic of the voice. Corrected for the
#'   formant filter.}
#'   \item{A1u}{Amplitude of the harmonic closest to the first formant peak
#'   frequency, in decibels.}
#'   \item{A1c}{Amplitude of the harmonic closest to the first formant peak
#'   frequency, in decibels. Corrected for the formant filter.}
#'   \item{A2u}{Amplitude of the harmonic closest to the second formant peak
#'   frequency, in decibels.}
#'   \item{A2c}{Amplitude of the harmonic closest to the second formant peak
#'   frequency, in decibels. Corrected for the formant filter.}
#'   \item{A3u}{Amplitude of the harmonic closest to the third formant peak
#'   frequency, in decibels.}
#'   \item{A3c}{Amplitude of the harmonic closest to the third formant peak
#'   frequency, in decibels. Corrected for the formant filter.}
#'   \item{H1H2u}{Difference between H1 and H2, in decibels.}
#'   \item{H1H2c}{Difference between H1 and H2, in decibels. Corrected for the
#'   formant filter.}
#'   \item{H2H4u}{Difference between H2 and H4, in decibels.}
#'   \item{H2H4c}{Difference between H2 and H4, in decibels. Corrected for the
#'   formant filter.}
#'   \item{H1A1u}{Difference between H1 and A1, in decibels.}
#'   \item{H1A1c}{Difference between H1 and A1, in decibels. Corrected for the
#'   formant filter.}
#'   \item{H1A2u}{Difference between H1 and A2, in decibels.}
#'   \item{H1A2c}{Difference between H1 and A2, in decibels. Corrected for the
#'   formant filter.}
#'   \item{H1A3u}{Difference between H1 and A3, in decibels.}
#'   \item{H1A3c}{Difference between H1 and A3, in decibels. Corrected for the
#'   formant filter.}
#'   \item{Energy}{Root mean square energy.}
#'   \item{HNR05}{Harmonics-to-noise ratio between 0-500 Hz.}
#'   \item{HNR15}{Harmonics-to-noise ratio between 0-1500 Hz.}
#'   \item{HNR25}{Harmonics-to-noise ratio between 0-2500 Hz.}
#'   \item{HNR35}{Harmonics-to-noise ratio between 0-3500 Hz.}
#'   \item{CPP}{Cepstral peak prominence, in decibels.}
#'   \item{SHR}{Amplitude ratio between subharmonics and harmonics (Sun 2002).
#'   If there is a `0` in this column, please be aware that it sometimes
#'   indicates bad data.}
#' }
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"acoustics"

#' Electroglottography measurements for the UCLA voice quality project
#'
#' Electroglottography measurements from recordings of Bo, Gujarati, Hmong,
#' Luchun, Mandarin, Miao, Yi, and Zapotec. Measurements are taken at nine
#' timepoints within each phonetic segment (vowel or consonant).
#'
#' This documentation is based on the the spreadsheet key on the
#' \href{http://www.phonetics.ucla.edu/voiceproject/voice.html}{UCLA project
#' website}. Please see that page for more information about the corpus
#' (including the original EGG recordings) and for citation and licensing
#' instructions. The description of the EGG measures is from the
#' \href{http://www.appsobabble.com/functions/EGGWorks.aspx}{EGGWorks}
#' documentation (requires registration).
#'
#' This table is a version of the original EGG master spreadsheet converted to
#' the \href{https://r4ds.had.co.nz/tidy-data.html}{tidy data format} for use
#' with the tidyverse R packages. It has one row per timepoint, rather than one
#' row per filename, and one column per EGG measure, rather than nine timepoint
#' columns and one overall mean for each measure. Each phonetic segment in the
#' data has a unique combination of \code{filename} and \code{segment_start}
#' values, and each measurement has a unique combination of \code{filename},
#' \code{segment_start}, and \code{timepoint} values.
#'
#' Be aware that the \code{min_Vel}, \code{peak_Vel}, \code{ratio},
#' \code{SQ2_SQ1}, and \code{SQ4_SQ3} columns contain extreme values that are
#' most likely bad data. Be sure to check the distribution of the data before
#' doing any analyses.
#'
#' @examples
#' data("egg", package = "voicequality")
#'
#' @format A data frame with 133,254 rows and 32 variables: \describe{
#'   \item{speaker_id}{Speaker ID. Unique across all eight languages.}
#'   \item{speaker_number}{Speaker number or pseudonym. Unique within a language
#'   but not across languages.}
#'   \item{speaker_sex}{F for female or M for male.}
#'   \item{language}{Language that this word is from.}
#'   \item{language_variety}{Dialect of the language, or the location where this
#'   word was recorded.}
#'   \item{filename}{Filename of the corresponding EGG file. For a description
#'   of file naming conventions, see the PDF notes for each language on the
#'   project website.}
#'   \item{segment_start}{Start time of this phonetic segment in the EGG file,
#'   in milliseconds.}
#'   \item{segment_end}{End time of this phonetic segment in the EGG file, in
#'   milliseconds.}
#'   \item{duration}{Duration of this segment, in milliseconds.}
#'   \item{timepoint}{Time within the segment where these measurements were
#'   taken, as a number from 1 to 9. A 1 means that this row has measurements
#'   taken during the first ninth of the segment, a 2 means that it has
#'   measurements taken during the second ninth, etc.}
#'   \item{segment_type}{Whether the segment is a vowel or a consonant.}
#'   \item{vowel_quality}{Vowel quality for this segment. NA if these
#'   measurements are from a consonant.}
#'   \item{phonation}{Phonation type of the segment.}
#'   \item{vowel_nasality}{Whether the vowel is oral or nasal.}
#'   \item{consonant_aspiration}{Whether the consonant preceding the vowel is
#'   aspirated or unaspirated. If this segment is a consonant, then whether this
#'   segment is aspirated or unaspirated.}
#'   \item{tone_contour}{Sequence of tone targets for this tone type, using the
#'   standard IPA range with the numbers 1-5, where 1 is low, 3 is mid, and 5 is
#'   high. NA for languages without lexical tone.}
#'   \item{number_of_tone_targets}{Number of tone targets for this tone type,
#'   from 1 to 3.}
#'   \item{tone_category}{Label for tone contour, divided into four categories:
#'   high (55, 53, 45, 44, 535), mid (24, 33, 35, 31), low (22, 21, 11, 213,
#'   13), and big (51, 351, 15, 151, 153).}
#'   \item{language_specific_tone}{Tone label based on language-specific tone
#'   transcription conventions, which were also used to annotate tone in the
#'   original TextGrid file. For example, in Mandarin Chinese, the files were
#'   annotated with the traditional labels of Tone 1, 2, 3 or 4. The
#'   \code{tone_contour} and \code{tone_category} columns have the actual tone
#'   contours for each tone type.}
#'   \item{tone_misc}{...}
#'   \item{CQ}{Contact quotient, calculated with the standard method, which uses
#'   a pre-assigned percentage of the cycle height for the closure start time.}
#'   \item{CQ_H}{Contact quotient, calculated with a hybrid method, which uses
#'   the peak velocity time as the closure start time and a pre-assigned
#'   percentage of the cycle height for the closure end time.}
#'   \item{CQ_HT, CQ_PM}{Contact quotient, calculated using other methods.
#'   See the \href{http://www.appsobabble.com/functions/EGGWorks.aspx}{EGGWorks}
#'   website by Henry Tehrani for a description of these methods.}
#'   \item{min_Vel}{Cycle minimum velocity.}
#'   \item{min_Vel_Time}{Cycle minimum velocity time.}
#'   \item{peak_Vel}{Cycle peak velocity.}
#'   \item{peak_Vel_Time}{Cycle peak velocity time.}
#'   \item{SQ2_SQ1}{Duration of the closing slope, calculated as the time from
#'   when the cycle reaches 10\% of its minimum value to when the cycle reaches
#'   90\% of its minimum value.}
#'   \item{SQ4_SQ3}{Duration of the opening slope, calculated as the time from
#'   when the cycle reaches 90\% of its minimum value to when the cycle reaches
#'   10\% of its minimum value.}
#'   \item{ratio}{Ratio of closing slope to opening slope durations.}
#' }
#' @source
#'   \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
#'   \url{http://phonetics.linguistics.ucla.edu/facilities/physiology/egg.htm}
#'   \url{http://www.appsobabble.com/functions/EGGWorks.aspx}
"egg"

#' Word list for Bo
#'
#' List of words elicited in recordings of Bo for the UCLA voice quality
#' project.
#'
#' Data collection credit: Jianjing Kuang of UCLA, fieldwork in two Bo villages
#' (Shizong and Xingfucun) in summer 2009.
#'
#' @examples
#' data("bo_word_list", package = "voicequality")
#'
#' @format A data frame with 79 rows and 3 variables:
#' \describe{
#'   \item{transcription}{Phonetic transcription of the word. See PDF notes on
#'   the project website for IPA equivalents.}
#'   \item{english_gloss}{English gloss of the word.}
#'   \item{mandarin_gloss}{Mandarin gloss of the word.}
#' }
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"bo_word_list"

#' Word list for Gujarati
#'
#' List of words elicited in recordings of Gujarati for the UCLA voice quality
#' project.
#'
#' Data collection credit: Sameer Khan of UCLA, recordings all made in the
#' soundbooth of the UCLA Phonetics Lab, in 2008-2009.
#'
#' @examples
#' data("gujarati_word_list", package = "voicequality")
#'
#' @format A data frame with 75 rows and 5 variables:
#' \describe{
#'   \item{file_number}{The number used in the audio filenames to refer to this
#'   word. For example, if a filename is \code{2008-11-21-1330-01}, the last
#'   number (01) indicates that the audio file is a recording of the word in
#'   this table with a \code{file_number} of 01.}
#'   \item{target_pronunciation}{Expected pronunciation of the word, which is
#'   not necessarily the actual production of the speaker.}
#'   \item{dictionary_pronunciation}{Dictionary pronunciation of the word.}
#'   \item{target_vowel}{Transcription of the vowel (or vowel with preceding
#'   aspiration) that was extracted from this word.}
#'   \item{gloss}{English gloss of the word.}
#' }
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"gujarati_word_list"

#' Word list for Hmong
#'
#' List of words elicited in recordings of Hmong for the UCLA voice quality
#' project.
#'
#' Data collection credit: Recordings were made by Christina Esposito of
#' Macalester College and Sherrie Yang of UCLA at the Hmong American Partnership
#' (St. Paul, Minnesota) and the Immmanuel Hmong Lutheran Church (St. Paul,
#' Minnesota) in summer 2008.
#'
#' @examples
#' data("hmong_word_list", package = "voicequality")
#'
#' @format A data frame with 163 rows and 5 variables:
#' \describe{
#'   \item{index}{Index for the word, not used in the filenames.}
#'   \item{orthography}{Spelling of the word.}
#'   \item{IPA}{Phonetic transcription of the word in IPA.}
#'   \item{gloss}{English gloss of the word.}
#'   \item{language_variety}{Whether the word is from White Hmong or Green
#'   Hmong.}
#' }
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"hmong_word_list"

#' Word list for Luchun
#'
#' List of words elicited in recordings of Luchun by Professor Jiangping Kong of
#' Peking University during fieldwork in Luchun village in summer 2009. Included
#' in the UCLA voice quality project.
#'
#' @examples
#' data("luchun_word_list", package = "voicequality")
#'
#' @format A data frame with 108 rows and 2 variables:
#' \describe{
#'   \item{index}{Index for the word, not used in the filenames.}
#'   \item{transcription}{Phonetic transcription of the word. See PDF notes on
#'   the project website for IPA equivalents.}
#' }
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"luchun_word_list"

#' Word list for Mazatec
#'
#' List of words elicited in recordings of Mazatec by Paul Kirk in 1982 and
#' brought to UCLA in 1984; and by Paul Kirk, Peter Ladefoged, and others from
#' UCLA in 1993. Included in the UCLA voice quality project.
#'
#' @examples
#' data("mazatec_word_list", package = "voicequality")
#'
#' @format A data frame with 82 rows and 6 variables:
#' \describe{
#'   \item{filename}{Transcription used in the audio filenames to refer to this
#'   word.}
#'   \item{IPA}{Phonetic transcription of the word in IPA.}
#'   \item{gloss}{English gloss of the word.}
#'   \item{orthography}{Spelling of the word. Not available for 1984
#'   recordings.}
#'   \item{index}{Index number from the UCLA Phonetic Database.}
#' }
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"mazatec_word_list"

#' Word list for Miao minimal sets
#'
#' List of minimal sets elicited in recordings of Miao for the UCLA voice
#' quality project.
#'
#' Data collection credit: Jianjing Kuang of UCLA, in Shidong Kou
#' (Shih-Tung-K'ou), Taijiang (T'ai-Kung) county of Guizhou (Kweichow) province,
#' China, in summer 2011.
#'
#' @examples
#' data("miao_minimal_sets", package = "voicequality")
#'
#' @format A data frame with 87 rows and 4 variables:
#' \describe{
#'   \item{tone}{Sequence of tone targets for this tone type, using the
#'   standard IPA range with the numbers 1-5, where 1 is low, 3 is mid, and 5 is
#'   high.}
#'   \item{IPA}{Phonetic transcription of the word in IPA.}
#'   \item{gloss}{English gloss of the word.}
#'   \item{minimal_set_id}{Identifier for all members of a minimal set. For
#'   example, all rows with \code{minimal_set_id} of 1 belong to a minimal set,
#'   all rows with \code{minimal_set_id} of 2 belong to a different minimal set,
#'   etc.}
#' }
#' @family Miao word lists
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"miao_minimal_sets"

#' Word list for other Miao words
#'
#' List of other words, besides minimal sets, elicited in recordings of Miao for
#' the UCLA voice quality project.
#'
#' Data collection credit: Jianjing Kuang of UCLA, in Shidong Kou
#' (Shih-Tung-K'ou), Taijiang (T'ai-Kung) county of Guizhou (Kweichow) province,
#' China, in summer 2011.
#'
#' @examples
#' data("miao_other_words", package = "voicequality")
#'
#' @format A data frame with 39 rows and 3 variables:
#' \describe{
#'   \item{IPA}{Phonetic transcription of the word in IPA.}
#'   \item{tone}{Sequence of tone targets for this tone type, using the
#'   standard IPA range with the numbers 1-5, where 1 is low, 3 is mid, and 5 is
#'   high.}
#'   \item{gloss}{English gloss of the word.}
#' }
#' @family Miao word lists
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"miao_other_words"

#' Miao filename metadata
#'
#' Metadata for audio files of Miao recordings in the UCLA voice quality
#' project.
#'
#' Data collection credit: Jianjing Kuang of UCLA, in Shidong Kou
#' (Shih-Tung-K'ou), Taijiang (T'ai-Kung) county of Guizhou (Kweichow) province,
#' China, in summer 2011.
#'
#' @examples
#' data("miao_filename_list", package = "voicequality")
#'
#' @format A data frame with 1,697 rows and 6 variables:
#' \describe{
#'   \item{speaker}{Speaker name.}
#'   \item{code}{Code for speaker.}
#'   \item{transcription}{Phonetic transcription of the word. See PDF notes on
#'   the project website for IPA equivalents.}
#'   \item{gloss}{English gloss of the word.}
#' }
#' @family Miao word lists
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"miao_filename_list"

#' Word list for Yi tense/lax minimal pairs
#'
#' List of tense/lax minimal pairs elicited in recordings of Yi for the UCLA
#' voice quality project.
#'
#' Data collection credit: Jianjing Kuang of UCLA, fieldwork in two southern Yi
#' villages (Xinping and Jiangcheng) in summer 2009.
#'
#' @examples
#' data("yi_tense_lax", package = "voicequality")
#'
#' @format A data frame with 82 rows and 5 variables:
#' \describe{
#'   \item{vowel}{Transcription of the vowel that was extracted from this word.}
#'   \item{tense_lax}{Whether the vowel is tense or lax.}
#'   \item{minimal_pair_id}{Identifier for all members of a minimal set. For
#'   example, the rows with \code{minimal_pair_id} of 1 belong to a minimal
#'   pair, the rows with \code{minimal_pair_id} of 2 belong to a different
#'   minimal pair, etc.}
#'   \item{IPA}{Phonetic transcription of the word in IPA.}
#'   \item{english_gloss}{English gloss of the word.}
#' }
#' @family Yi word lists
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"yi_tense_lax"

#' Word list for Yi showing the phonation contrast on different vowels
#'
#' List of tense/lax minimal pairs elicited in recordings of Yi for the UCLA
#' voice quality project.
#'
#' Data collection credit: Jianjing Kuang of UCLA, fieldwork in two southern Yi
#' villages (Xinping and Jiangcheng) in summer 2009.
#'
#' @examples
#' data("yi_vowels", package = "voicequality")
#'
#' @format A data frame with 38 rows and 4 variables:
#' \describe{
#'   \item{vowel}{Transcription of the vowel that was extracted from this word.}
#'   \item{minimal_pair_id}{Identifier for all members of a minimal pair. For
#'   example, the rows with \code{minimal_pair_id} of 1 belong to a minimal
#'   pair, the rows with \code{minimal_pair_id} of 2 belong to a different
#'   minimal pair, etc.}
#'   \item{english_gloss}{English gloss of the word.}
#'   \item{IPA}{Phonetic transcription of the word in IPA.}
#' }
#' @family Yi word lists
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"yi_vowels"

#' Word list for Yi showing the phonation contrast on different tones
#'
#' List of tense/lax minimal pairs elicited in recordings of Yi for the UCLA
#' voice quality project.
#'
#' Data collection credit: Jianjing Kuang of UCLA, fieldwork in two southern Yi
#' villages (Xinping and Jiangcheng) in summer 2009.
#'
#' @examples
#' data("yi_tones", package = "voicequality")
#'
#' @format A data frame with 86 rows and 4 variables:
#' \describe{
#'   \item{tone}{Sequence of tone targets for this tone type, using the
#'   standard IPA range with the numbers 1-5, where 1 is low, 3 is mid, and 5 is
#'   high.}
#'   \item{tense_lax}{Whether the vowel is tense or lax.}
#'   \item{minimal_set_id}{Identifier for all members of a minimal set. For
#'   example, all rows with \code{minimal_set_id} of 1 belong to a minimal
#'   set, all rows with \code{minimal_set_id} of 2 belong to a different
#'   minimal set, etc.}
#'   \item{english_gloss}{English gloss of the word.}
#'   \item{IPA}{Phonetic transcription of the word in IPA.}
#' }
#' @family Yi word lists
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"yi_tones"

#' Word list for Zapotec
#'
#' List of words elicited in recordings of Zapotec for the UCLA voice quality
#' project.
#'
#' Data collection credit: Christina Esposito, with assistance from Alvaro Luna,
#' at various locations in the Koreatown area of Los Angeles, in summer 2010.
#'
#' @examples
#' data("zapotec_word_list", package = "voicequality")
#'
#' @format A data frame with 48 rows and 5 variables:
#' \describe{
#'   \item{index}{Index used in the audio filenames to refer to this word. For
#'   example, if a filename is \code{speaker3M_aC34}, the last number (34)
#'   indicates that the audio file is a recording of the word in this table with
#'   an \code{index} of 34.}
#'   \item{IPA}{Phonetic transcription of the word in IPA.}
#'   \item{orthography}{Spelling of the word.}
#'   \item{english_gloss}{English gloss of the word.}
#'   \item{spanish_gloss}{Spanish gloss of the word.}
#'   \item{phonation}{Phonation type of the segment.}
#' }
#' @source \url{http://www.phonetics.ucla.edu/voiceproject/voice.html}
"zapotec_word_list"
