*** Settings ***
Documentation     Data-driven: create several Contacts from a table.
Resource          ../resources/common.resource
Suite Setup       Run Keywords    Setup Browser    AND    Login To Salesforce
Suite Teardown    End Suite
Test Template     Create Contact And Verify
Test Tags         regression    contact

*** Test Cases ***              FIRST       LAST          EMAIL
Contact With Email              Priya       Kumar         priya.kumar@example.com
Contact With Long Last Name     John        Smith-Johnson john.sj@example.com
Contact Without Email           Ana         Lopez         ${EMPTY}

*** Keywords ***
Create Contact And Verify
    [Arguments]       ${first}    ${last}    ${email}
    ${suffix}=        Unique Suffix
    ${last_unique}=   Set Variable    ${last}${suffix}
    Open New Record Form    Contact
    TypeText          First Name      ${first}
    TypeText          Last Name       ${last_unique}
    Run Keyword If    '${email}' != ''    TypeText    Email    ${email}
    Save Record
    VerifyText        ${first} ${last_unique}
