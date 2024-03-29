# This script builds both the HTML and PDF versions of your
# CV
library(fs)
library(rmarkdown)
library(pagedown)
library(pdftools)
# declare param inputs to render
sheet_ss_id <- "1SqkIDpyVfurLA0DXRgcsZ9aba_Bk9bvak0sGRCLsVX0"
online_link <- "https://justingregoire.me/resume.html"
pdf_location <- "https://github.com/jtgregoire93/justingregoire.me/raw/main/pdf/jgregoire_resume.pdf"
# Knit the HTML version
rmarkdown::render("resume_gen/resume_generation.Rmd", params = list(pdf_export = FALSE,
  sheet_ss_id = sheet_ss_id, online_link = online_link, pdf_location = pdf_location),
  output_file = "resume_download.html")

# Knit the PDF version to temporary html location
tmp_html_cv_loc <- fs::file_temp(ext = ".html")
rmarkdown::render("resume_gen/resume_generation.Rmd", params = list(pdf_export = TRUE,
  sheet_ss_id = sheet_ss_id, online_link = online_link, pdf_location = pdf_location),
  output_file = tmp_html_cv_loc)

# Convert to PDF using Pagedown
pagedown::chrome_print(input = tmp_html_cv_loc, output = "pdf/resume_pre.pdf")
pdftools::pdf_compress("pdf/resume_pre.pdf", output = "pdf/jgregoire_resume.pdf")

