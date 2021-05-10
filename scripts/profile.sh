#!/usr/bin/env bash

# 쉬고있는 profile 찾기: production1 이 사용중이면 production2 가 쉬고있고, 반대면 production1 이 쉬고있음

function find_idle_profile()
{
    RESPONSE_CODE=$(sudo curl -s -o /dev/null -w "%{http_code}" http://3.36.81.228/profile)

    if [ ${RESPONSE_CODE} -ge 400 ] # 400 보다 크면 (즉, 40x/50x 에러 모두 포함)
    then
        CURRENT_PROFILE=production2
    else
        CURRENT_PROFILE=$(sudo curl -s http://3.36.81.228/profile)
    fi

    if [ ${CURRENT_PROFILE} == production1 ]
    then
      IDLE_PROFILE=production2
    else
      IDLE_PROFILE=production1
    fi

    echo "${IDLE_PROFILE}"    # bash script는 return 기능이 없기 떄문에 echo를 통해서 출력하면 이 값을 클라이언트가 사용할 수 있습니다.
}
# 쉬고 있는 profile의 port 찾기
function find_idle_port()
{
    IDLE_PROFILE=$(find_idle_profile)

    if [ ${IDLE_PROFILE} == production1 ]
    then
      echo "8081"   # 여기도 마찬가지로 return 기능의 느낌
    else
      echo "8082"   # 여기도 마찬가지로 return 기능의 느낌
    fi
}
