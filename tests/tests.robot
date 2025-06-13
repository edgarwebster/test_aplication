*** Settings ***
Library           RequestsLibrary

Suite Setup       Create Session    todo    http://localhost:5000
Suite Teardown    Delete All Tasks

*** Test Cases ***

Criar nova tarefa
    ${body}=    Create Dictionary    title=Estudar Robot Framework
    ${response}=    Post Request    todo    /tasks    json=${body}
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    id

Listar tarefas
    ${response}=    Get Request    todo    /tasks
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be True    ${response.json()}[0]['title'] == 'Estudar Robot Framework'

Atualizar tarefa
    ${body}=    Create Dictionary    title=Estudar RF    done=True
    ${response}=    Put Request    todo    /tasks/1    json=${body}
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.json()}    Estudar RF

Deletar tarefa
    ${response}=    Delete Request    todo    /tasks/1
    Should Be Equal As Integers    ${response.status_code}    204

Verificar tarefa removida
    ${response}=    Get Request    todo    /tasks
    Length Should Be    ${response.json()}    0

*** Keywords ***
Delete All Tasks
    ${response}=    Get Request    todo    /tasks
    FOR    ${task}    IN    @{response.json()}
        Delete Request    todo    /tasks/${task['id']}
    END
