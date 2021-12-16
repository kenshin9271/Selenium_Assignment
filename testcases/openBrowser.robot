*** Settings ***
Documentation     Simple example using SeleniumLibrary.
Resource          ../common/resources.robot

*** Variables ***

${SearchBox}    //input[contains(@id,'twotabsearchtextbox')]
${Query}    laptop
${SearchBtn}    //input[contains(@id,'nav-search-submit-button')]
${FirstSearchResult}    (//a[contains(@class,'a-link-normal s-no-outline')])[1]
${ItemPrice}    (//*[contains(@class,'a-price')]//*[contains(text(),"$")])[2]
${MinimumPrice}    100

*** Keywords ***

Check Page Title
    [Arguments]    ${ExpectedTitle}
    ${Title}=    Get Title
    ${Title}=    Get Regexp Matches    ${Title}    ${ExpectedTitle}
    Should Be Equal    ${Title}[0]    ${ExpectedTitle}

Input Query and Click Search
    [Arguments]    ${InputQuery}
    Wait Until Element Is Visible    ${SearchBox}    30
    Input Text    ${SearchBox}    ${InputQuery}
    Sleep    3
    Wait Until Element Is Visible    ${SearchBtn}    30
    Click Button    ${SearchBtn}
    Sleep    3
    Wait For Condition    return document.readyState=="complete"    30
    Wait Until Element Is Visible    ${FirstSearchResult}    30
    Click Link    ${FirstSearchResult}
    Sleep    3

Get Item Price
    Wait For Condition    return document.readyState=="complete"    30
    ${ItemPrice}=    Get Text    ${ItemPrice}
    ${ItemPrice}=    Get Regexp Matches    ${ItemPrice}    \\d*\\.\\d*
    ${ItemPrice}=    Evaluate    ${ItemPrice}[0]
    ${ItemPrice} =    Convert To Number    ${ItemPrice}
    [Return]    ${ItemPrice}

*** Test Cases ***

Amazon Laptop Test
    Launch Chrome   #launch chrome with specific options
    Go To   ${HOME URL}    # go to amazon.com
    Wait For Condition    return document.readyState=="complete"    #wait for the webpage to finish loading
#    Debug
    Check Page Title    Amazon.com    #check page title contains the string "Amazon.com"
    Input Query and Click Search    ${Query}    #key in search query in the searchbar and click search
    ${ItemPrice}=    Get Item Price    #read the item price and store it in variable
    Should Be True     ${ItemPrice}>${MinimumPrice}    #assert that the item price is more than the minimum price

    [Teardown]    Custom Teardown    #end of test procedures



