import time
import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException


login_page_link = 'https://www.linkedin.com/login'
search_page_link = 'https://www.linkedin.com/jobs/search/?geoId=103644278&keywords=data%20scientist&location=United%20States&refresh=true'
job_list_item_class = 'job-card-list__title'
job_title_xpath = '//span[contains(@class, "topcard__title")]' 
company_name_xpath = '//span[contains(@class, "topcard__flavor")]'

username_id = 'username'
password_id = 'password'
login_btn_xpath = '//button[@type="submit" and @aria-label="Sign in"]'


def get_browser_driver():
    browser = webdriver.Chrome(executable_path='/Users/justingregoire/Developer/Personal/justingregoire.me/chromedriver_mac_arm64/chromedriver')
    browser.maximize_window()
    return browser


def login_to_linkedin(browser):
    browser.get(login_page_link)
    browser.find_element(by=By.ID, value=username_id).send_keys("jtgregoire93@gmail.com")
    browser.find_element(by=By.ID, value=password_id).send_keys("Greg1!2@")
    login_btn = browser.find_element(by=By.XPATH, value=login_btn_xpath)
    login_btn.click()
    time.sleep(5)


def load_search_results_page(browser):
    browser.get(search_page_link)
    time.sleep(5)


def get_job_post_data(browser):
    job_posts = []
    job_cards = browser.find_elements(by=By.CLASS_NAME, value=job_list_item_class)

    for job_card in job_cards:
        job_id = job_card.get_attribute('data-job-id')
        job_dict = {}
        browser.execute_script("arguments[0].scrollIntoView();", job_card)
        job_card.click()
        time.sleep(5)

        job_dict['Job ID'] = job_id
        job_dict['Job title'] = get_element_text_by_xpath(browser, job_title_xpath)
        job_dict['Company name'] = get_element_text_by_xpath(browser, company_name_xpath)

        job_posts.append(job_dict)
    return job_posts


def get_element_text_by_xpath(browser, xpath):
    return browser.find_element(by=By.XPATH, value=xpath).text


browser = get_browser_driver()
login_to_linkedin(browser)
load_search_results_page(browser)
jobs_list = get_job_post_data(browser)
jobs_df = pd.DataFrame(jobs_list)

print(jobs_df)