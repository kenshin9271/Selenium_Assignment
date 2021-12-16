*** Settings ***
Documentation     A resource file with reusable keywords and variables.

Library		      String
Library           DateTime
Library           SeleniumLibrary
Library           DebugLibrary


*** Variables ***
${BROWSER}    Chrome
${HOME URL}    https://www.amazon.com/
&{browser logging capability}    browser=ALL
@{chrome_arguments}    --disable-infobars    # to hide all infobar which could block some elements
...                    --goog:loggingPrefs=${browser logging capability}    # to log console error
...                    --window-size=1280,1024
#...                    --headless     # run test in headless mode (browser will not be visibled)
#...                    --auto-open-devtools-for-tabs    # to open devtool by default
...                    --disable-gpu
#...                    --disable-dev-shm-usage
#...                    --ignore-certificate-errors
#...                    --no-sandbox


*** Keywords ***

Set Chrome Options
    [Documentation]   Set Chrome options for headless mode
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    FOR    ${option}    IN    @{chrome_arguments}
        Call Method    ${options}    add_argument    ${option}
    END
    [Return]    ${options}

Launch Chrome
    ${chrome_options}=    Set Chrome Options
    Create Webdriver    Chrome    chrome_options=${chrome_options}


Print Browser Console Log Entries
    ${selenium}=    Get Library Instance    SeleniumLibrary
    ${webdriver}=    Set Variable     ${selenium._drivers.active_drivers}[0]
    ${log entries}=    Evaluate    $webdriver.get_log('browser')
    Log To Console    Test is failing, here is the console log:
    Log To Console    ${log entries}

Take Screenshot For Failed Test
    ${date} =	Get Current Date    	result_format=%d_%m_%Y_%H_%M
    Capture Page Screenshot    failed_test_${TEST_NAME}_${date}.png

Custom Teardown
    Run Keyword If Test Failed    Take Screenshot For Failed Test
    Log To Console    HEllo PANDA
    Close All Browsers

Stop Test With Screenshot
    [arguments]    ${msg}
    Capture Page Screenshot    failed_test_${TEST_NAME}.png    #for debugging purposes
    Fail    msg=${msg}
