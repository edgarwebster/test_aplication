*** Settings ***
Library           RequestsLibrary
Library           Collections

Suite Setup       Create Session    todo    http://host.docker.internal:5000
Suite Teardown    Delete All Tasks

*** Test Cases ***

Criar nova tarefa
    ${body}=    Create Dictionary    title=Estudar Robot Framework
    ${response}=    POST On Session    todo    /tasks    json=${body}
    Should Be Equal As Integers    ${response.status_code}    201
    Should Contain    ${response.json()}    id

Listar tarefas
    ${response}=    GET On Session    todo    /tasks
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[0][title]    Estudar Robot Framework

Atualizar tarefa
    ${body}=    Create Dictionary    title=Estudar RF    done=True
    ${response}=    PUT On Session    todo    /tasks/1    json=${body}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()}[title]    Estudar RF

Deletar tarefa
    ${response}=    DELETE On Session    todo    /tasks/1
    Should Be Equal As Integers    ${response.status_code}    204

Verificar tarefa removida
    ${response}=    GET On Session    todo    /tasks
    Length Should Be    ${response.json()}    0

*** Keywords ***
Delete All Tasks
    ${response}=    GET On Session    todo    /tasks
    FOR    ${task}    IN    @{response.json()}
        DELETE On Session    todo    /tasks/${task['id']}
    END
