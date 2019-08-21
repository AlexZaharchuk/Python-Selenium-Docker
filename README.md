# Container for running Python Selenium tests on docker

This container is a configuration of all the necessary packages and modules for running Selenium tests inside the docker.
Container configuration allows you to run Chrome Driver in the background and automatically run user interface tests in Python.

# Example usage
## Usage in Dockerfile
`
FROM thexela/ubuntu-python-selenium

# run tests
COPY . $APP_HOME/
RUN pytest --path=$APP_HOME/tests
`

## Python tests configuraion
`
class TestExample(object):
    def setup_method(self, method):
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument('user-agent={0}'.format(MY_USER_AGENT))
        chrome_options.add_argument("--enable-javascript")
        chrome_options.add_argument('--ignore-certificate-errors')
        chrome_options.add_argument('--no-sandbox')
        chrome_options.add_argument('--window-size=1420,1080')
        chrome_options.add_argument('--headless')
        chrome_options.add_argument('--disable-gpu')
        
        # create virtual display
        self.display = Display(visible=0, size=(1920, 1080))
        self.display.start()
        self.driver = webdriver.Chrome(chrome_options=chrome_options)
        self.driver.set_window_size(1920, 1080)
        self.vars = {}

    def teardown_method(self, method):
        self.driver.quit()

    def test_1_my_test(self):
        self.driver.get("https://my-site.com")
        self.driver.find_element(By.ID, "companyName").click()
        self.driver.find_element(By.ID, "companyName").send_keys("myCompany")
        self.driver.find_element(By.ID, "userName").click()
        self.driver.find_element(By.ID, "userName").send_keys("myLogin")
        self.driver.find_element(By.ID, "password").click()
        self.driver.find_element(By.ID, "password").send_keys("1111")
        self.driver.find_element(By.ID, "password").send_keys(Keys.ENTER)
`
