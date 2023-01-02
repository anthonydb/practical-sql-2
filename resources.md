# 실용 SQL: PostgreSQL로 시작하는 데이터 스토리텔링 가이드북


## PostgreSQL 추가 자료

부록에는 PostgreSQL를 사용한 개발 관련 최신 정보를 얻고, 추가 소프트웨어를 찾고 도움을 받는 데 도움이 되는 자료를 정리했습니다.

## PostgreSQL 개발 환경

책에서는 pgAdmin을 사용하여 PostgreSQL에 연결하고 쿼리를 실행하고 데이터베이스 개체를 확인합니다. [pgAdmin](https://www.pgadmin.org)은 무료이며 오픈소스이며 널리 사용되는 그래픽 사용자 인터페이스이지만 PostgreSQL 작업에 사용할 수 있는 프로그램이 많습니다. PostgreSQL 위키의 ‘[PostgreSQL 클라이언트](https://wiki.postgresql.org/wiki/PostgreSQL_Clients)’에는 다양한 대안이 나열되어 있습니다.

아래는 저자가 사용했던 다양한 프로그램들을 정리했습니다. 무료 프로그램은 일반 분석 작업에 적합합니다. 데이터베이스 개발에 대해 더 깊이 파고들려면 고급 기능을 사용할 수 있고 개발사에서 지원을 제공하는 유료 프로그램을 사용하길 권합니다.

[Beekeeper Studio](https://www.beekeeperstudio.io/): PostgreSQL과 MySQL, Microsoft SQL Server, SQLite 및 기타 플랫폼을 위한 무료 오픈소스 GUI입니다. Beekeeper는 Windows와 macOS, Linux에서 작동하며 데이터베이스 GUI 중에서 더욱더 세련된 앱 디자인 중 하나를 제공합니다.

[DBeaver](https://dbeaver.com/): PostgreSQL과 MySQL, 기타 여러 데이터베이스와 함께 작동하는 ‘범용 데이터베이스 도구’입니다. DBeaver에는 시각적 쿼리 작성기와 코드 자동 완성 기능 같은 고급 기능이 포함되어 있습니다. Windows와 macOS, Linux를 지원하며 유료 및 무료 버전이 있습니다.

[DataGrip](https://www.jetbrains.com/datagrip/): 코드 완성과 버그 감지, 코드 간소화를 위한 제안을 제공하는 SQL 개발 환경입니다. 유료 제품이지만 JetBrains는 학생, 교육자, 비영리 단체를 위한 할인 및 무료 버전을 제공합니다.

[Navicat](https://www.navicat.com/): PostgreSQL을 비롯해 MySQL, Oracle, MongoDB, Microsoft SQL Server를 포함한 다양한 데이터베이스를 지원하는 SQL 개발 환경입니다. Navicat은 무료 버전을 제공하지 않지만 14일 무료 평가판을 제공합니다.

[Postbird](https://github.com/Paxa/postbird/): 간단한 크로스 플랫폼 PostgreSQL GUI로 쿼리를 작성하고 개체를 보기 쉽게 해줍니다. 무료이며 오픈소스 프로그램입니다.

[Postico](https://eggerapps.at/postico/): Postgres.app 제작자가 Apple 디자인에서 힌트를 얻어 제작한 macOS 전용 클라이언트입니다. 정식 버전은 유료이지만 기능이 제한된 무료 버전이 있습니다.

[PSequel](https://www.psequel.com/): macOS 전용 클라이언트로 미니멀리스트를 위한 PostgreSQL 클라이언트입니다.

체험판을 사용하면 어떤 프로그램이 여러분에게 맞는지 알아볼 수 있습니다.

## PostgreSQL 유틸리티, 도구, 확장 프로그램

수많은 유틸리티와 도구, 확장 프로그램을 통해 PostgreSQL의 기능을 확장할 수 있습니다. 여기에는 추가 백업이나 가져오기/내보내기 옵션, 향상된 명령줄 형식, 강력한 통계 패키지에 이르기까지 다양합니다. [https://github.com/dhamaniasad/awesome-postgres/](https://github.com/dhamaniasad/awesome-postgres/)에서 선별한 프로그램들을 모아 두었지만 몇 가지 좋은 프로그램을 소개하겠습니다.

[PostgreSQL용 Devart 엑셀 추가 기능](https://www.devart.com/excel-addins/postgresql.html): 엑셀 통합 문서에서 PostgreSQL의 데이터를 직접 로드 하고 편집하게 해주는 엑셀 추가 기능입니다.

[MADlib](http://madlib.apache.org/): PostgreSQL과 통합되는 대규모 데이터셋용 기계 학습 및 분석 라이브러리입니다.

[pgAgent](https://www.pgadmin.org/docs/pgadmin4/development/pgagent.html): 다른 작업 중에서 예약된 시간에 쿼리를 실행할 수 있는 작업 관리자입니다.

[pgBackRest](https://pgbackrest.org/): 고급 데이터베이스 백업 및 복원 관리 도구입니다.

[pgcli](https://github.com/dbcli/pgcli/): 자동 완성 및 구문 강조 표시를 포함하는 `psql`의 대체 명령줄 인터페이스입니다.

[pgRouting](https://pgrouting.org/): PostGIS 지원 PostgreSQL 데이터베이스가 도로를 따라 주행 거리 찾기와 같은 네트워크 분석 작업을 수행할 수 있도록 합니다.

[PL/R](http://www.joeconway.com/plr.html): PostgreSQL 함수와 트리거 내에서 R 통계 프로그래밍 언어를 사용할 수 있도록 하는 절차 언어입니다.

[pspg](https://github.com/okbob/pspg/): `psql`의 출력을 정렬 및 스크롤 가능한 테이블로 형식화하며 여러 색상 테마를 적용할 수 있습니다.

## PostgreSQL 관련 뉴스, 커뮤니티 사이트

진정한 PostgreSQL 사용자라면 커뮤니티 뉴스를 계속 파악하길 추천합니다. PostgreSQL 개발 팀은 정기적으로 소프트웨어를 업데이트하며, 그러한 변경 사항이 기존 코드나 사용 중인 도구에 영향을 미칠 수 있습니다. 분석을 위한 새로운 기회를 찾을 수도 있습니다.

[EDB 블로그](https://www.enterprisedb.com/blog/): PostgreSQL 서비스 회사 EDB 팀의 블로그입니다. EDB는 이 책에서 언급한 Windows 설치 프로그램과 pgAdmin 개발을 주도하고 있습니다.

[Planet PostgreSQL](https://planet.postgresql.org/): 데이터베이스 커뮤니티의 블로그 게시물과 공지를 제공합니다.

[Postgres Weekly](https://postgresweekly.com/): PostgreSQL 관련 공지 사항, 블로그 게시물 및 제품 공지 사항을 정리한 이메일 뉴스레터입니다.

[PostgreSQL 메일링 리스트](https://www.postgresql.org/list/): 커뮤니티 전문가에게 질문하기 좋은 메일링 리스트입니다. pgsql-novice 및 pgsql-general 목록은 이메일이 과할 수도 있지만 초보자에게 유용합니다.

[PostgreSQL 뉴스 아카이브](https://www.postgresql.org/about/newsarchive/): PostgreSQL 개발 팀의 공식 소식입니다.

[PostgreSQL 유저 그룹](https://www.postgresql.org/community/user-groups/): 다음 링크에서 PostgreSQL 관련 모임 및 기타 활동을 운영하는 커뮤니티 그룹을 알 수 있습니다.

[PostGIS 블로그](http://postgis.net/blog/): PostGIS 확장에 대한 공지 및 업데이트가 올라옵니다.

또한 pgAdmin처럼 사용 중인 모든 PostgreSQL 관련 소프트웨어의 개발자 노트를 자세히 보길 추천합니다.

## 공식 문서

이 책 전체에서 PostgreSQL의 공식 문서를 자주 언급했습니다. [https://www.postgresql.org/docs/](https://www.postgresql.org/docs/)에 접속하면 FAQ나 위키, 각 버전에 대한 설명서를 찾을 수 있습니다. 인덱싱 같은 주제에 대해 자세히 알아보거나 기능과 함께 제공되는 모든 옵션을 알고 싶을 때 설명서에서 해당하는 섹션을 참고하길 추천합니다. 특히 ‘Preface’와 ‘Tutorial’, ‘SQL Language’는 이 책에서 소개한 내용을 다룹니다.

또한, [Postgres 가이드](http://postgresguide.com/)에서 다른 문서를 찾을 수 있으며, [Stack Overflow의 PostgreSQL 태그](https://stackoverflow.com/questions/tagged/postgresql/)에서 PostgreSQL 관련 질의응답을 확인할 수 있습니다. 또한 PostGIS에 대한 Q&A는 [Stack Overflow의 PostGIS 태그](https://gis.stackexchange.com/questions/tagged/postgis/)에서 찾아볼 수 있습니다.

