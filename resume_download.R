# Load required libraries
library(httr)

# Define the URL of the PDF file on GitHub
pdf_url <- "https://raw.githubusercontent.com/jtgregoire93/resume/main/jgregoire_resume.pdf"

# Define the destination path in your local repository
destination_path <- "jgregoire_resume.pdf"

# Download the PDF file
download.file(url = pdf_url, destfile = destination_path, mode = "wb")