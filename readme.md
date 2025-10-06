
밤의 침입자 (The Night Intruder) - 게임 기획서
1. 프로젝트 개요
1.1 게임 정보

장르: 추리 어드벤처, 인터랙티브 픽션
플랫폼: Android, iOS, Steam (Flutter 기반)
타겟: 추리 소설/게임 팬, 성인 (19세 이상 권장)
플레이 타임: 3-5시간 (1회 플레이스루)

1.2 게임 컨셉

경찰청 프로파일링센터 AI 전담 수사관이 되어 5일 안에 밀실 살인 사건을 해결
컴퓨터 앞에서 이메일, 증거, 사건 파일을 분석하며 AI와 협업(AI와 협업 부분은 탬플릿을 제공할 예정)
실제 수사관의 업무 환경을 시뮬레이션한 몰입형 UI/UX


2. 기술 스택 & 아키텍처
2.1 기술 스택
yamlFramework: Flutter 3.x
State Management: Provider / Riverpod
Local Storage: SharedPreferences (게임 진행 상태), Hive (증거/메일 데이터)
Platform: 
  - Android (minSdkVersion 21)
  - iOS (iOS 13+)
  - Steam (Windows/macOS via flutter desktop)
2.2 데이터 구조
로컬 데이터 관리 (No Backend):
- assets/ : 모든 게임 에셋 (JSON, 이미지, 텍스트)
- 게임 진행 상태 : SharedPreferences
- 증거/메일 잠금 상태 : Hive 로컬 DB

3. 화면 구조 & UI/UX 설계(모바일 환경이라면 반드시 가로모드로 실행)
3.1 화면 플로우
[스플래시] 
    ↓
[타이틀/메인 메뉴] 
    ↓
[게임 소개/튜토리얼]
    ↓
[메인 화면 (바탕화면)]
    ├─ [사건 파일 폴더]
    │   └─ [용의자 상세]
    ├─ [메일 폴더]
    │   └─ [메일 상세]
    ├─ [증거 폴더]
    │   └─ [증거 상세]
    └─ [AI 질문 패널]
        ├─ [질문하기 (-10 토큰)]
        ├─ [Think (-50 토큰)]
        └─ [Ultra Think (-100 토큰)]
3.2 메인 화면 (메인화면.png)
3.2.1 레이아웃
dart구성:
┌─────────────────────────────────────┐
│  ☰   D-3 14:00 PM        [제출하기] │  ← 상단바
├─────────────────────────────────────┤
│                                     │
│   [사건 파일]  [메일(1)]  [증거]    │  ← 폴더 아이콘
│                                     │
│                                     │
│        [탐정 실루엣 배경]            │  ← 배경 이미지
│                                     │
│                                     │
├─────────────────────────────────────┤
│ [VIT AI 분석으로 사건을 해결하세요] │  ← AI 입력창
│                        [✦]          │
└─────────────────────────────────────┘
3.2.2 컴포넌트 상세
상단바 (AppBar)
dart- 햄버거 메뉴 (☰): 설정, 게임 저장, 종료
- 타이머: "D-3 14:00 PM" (Day, 시간 표시)
- 제출하기: 최종 범인 지목 버튼 (Day 5 활성화)
- 토큰 표시: "Token: 500" (우측 상단)
폴더 아이콘 (GridView)
dart[사건 파일]
- 아이콘: 📁 (회색 폴더)
- 상태: 항상 활성화
- 뱃지: 없음

[메일]
- 아이콘: ✉️ (메일 봉투)
- 상태: 읽지 않은 메일 있을 때 빨간 뱃지 "1"
- 애니메이션: 새 메일 도착 시 흔들림

[증거]
- 아이콘: 📷 (카메라)
- 상태: 새 증거 추가 시 파란 뱃지
- 개수 표시: 우측 하단 "3개"
배경 이미지
dart- 탐정 실루엣 (세로 중앙)
- 노이즈 효과 (필름 그레인)
- 어두운 톤 (#1a1a1a)
AI 입력창 (하단 고정)
dartContainer:
  - 반투명 검정 배경 (opacity: 0.8)
  - 흰색 텍스트 필드
  - 우측 별 아이콘 [✦] (AI 메뉴 열기)
  
클릭 시:
  → AI 질문 패널 바텀 시트 표시

3.3 사건 파일 화면 (사건_파일.png)
3.3.1 레이아웃
dart┌─────────────────────────────────────┐
│  ← 사건 파일          [브리핑 다시보기]│  ← AppBar
├─────────────────────────────────────┤
│                                     │
│  ┌─────────┐    ┌─────────┐        │
│  │[사진]   │    │[사진]   │        │
│  │한지은   │    │박준영   │        │
│  │전 부인  │    │친구,공동│        │
│  │         │    │창업자   │        │
│  └─────────┘    └─────────┘        │
│                                     │
│  ┌─────────┐                        │
│  │[사진]   │                        │
│  │김수현   │                        │
│  │비서     │                        │
│  │         │                        │
│  └─────────┘                        │
│                                     │
└─────────────────────────────────────┘
3.3.2 기능
dart- 용의자 카드: GridView (2열)
- 각 카드 클릭 → 용의자 상세 화면
- 카드 정보:
  * 프로필 사진 (흑백 필터)
  * 이름 (한자)
  * 관계 (1줄)
  * 직업 (1줄)

3.4 용의자 상세 (용의자_상세.png)
3.4.1 레이아웃
dart┌─────────────────────────────────────┐
│  ← 용의자 상세                       │
├─────────────────────────────────────┤
│  ┌─────────┐         ┌──────────┐  │
│  │[프로필] │         │ ✦        │  │
│  │한지은   │         │VIT AI 분석│  │
│  │전 부인  │         │범인 확률 │  │
│  │프리랜서 │         │   48%    │  │
│  └─────────┘         └──────────┘  │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 발견한 증거                  │   │
│  │ 발견한 증거를                │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 수사 노트                    │   │
│  │                             │   │
│  └─────────────────────────────┘   │
└─────────────────────────────────────┘
3.4.2 섹션 구성
dart1. 프로필 카드 (좌측):
   - 사진 (원형)
   - 이름, 나이
   - 관계
   - 직업
   
2. AI 분석 (우측):
   - 별 아이콘
   - "VIT AI 분석 결과"
   - 범인 확률 (%, 큰 글씨)
   - 업데이트 시간 표시

3. 발견한 증거 (스크롤):
   - 이 용의자 관련 증거만 필터링
   - 카드 형태로 나열
   - 클릭 시 증거 상세

4. 수사 노트 (하단):
   - 플레이어가 직접 메모 작성
   - 자동 저장
   - 음성 입력 지원 (옵션)

3.5 메일 화면 (메일.png)
3.5.1 메일함 리스트
dart┌─────────────────────────────────────┐
│  ← 메일                              │
├─────────────────────────────────────┤
│  ┌────────────────────────────┐    │
│  │ 👤 국과수              📎 3개 │    │
│  │ 현장에서 발견된 증거물에...    │    │
│  │                            │    │
│  └────────────────────────────┘    │
│                                     │
│  ┌────────────────────────────┐    │
│  │ 👤 나형사             📎 1개 │    │
│  │ 사건 당일 밤 11시경, 현장...   │    │
│  │                            │    │
│  └────────────────────────────┘    │
│                                     │
│  ┌────────────────────────────┐    │
│  │ 👤 경찰청            📎 1개 │    │
│  │ 수색 영장 승인건               │    │
│  │                            │    │
│  └────────────────────────────┘    │
└─────────────────────────────────────┘
3.5.2 메일 카드 디자인
dartContainer (어두운 배경):
  Row:
    - 발신자 아이콘 (왼쪽)
    - Column:
      * 발신자 이름 + 첨부파일 개수
      * 제목 (굵게)
      * 미리보기 (2줄, 흐리게)
      * 시간 (우측 하단)
    - 읽음 표시 (파란 점)
3.5.3 메일 상세
dart┌─────────────────────────────────────┐
│  ← 메일                              │
├─────────────────────────────────────┤
│  From: 국과수                        │
│  To: 프로파일링센터                  │
│  Date: 2025-10-28 10:35             │
│  Subject: ⚠️ 긴급 - 부검 결과       │
│                                     │
│  [본문 텍스트]                       │
│  긴급: 자연사가 아닙니다...          │
│                                     │
│  📎 첨부파일 (3개):                  │
│  ┌────────────┐                     │
│  │부검보고서.pdf│                     │
│  └────────────┘                     │
│  ┌────────────┐                     │
│  │현장사진.jpg │                     │
│  └────────────┘                     │
│                                     │
│  [💰 보강 수사 (-20 토큰)]          │  ← 선택적 표시
└─────────────────────────────────────┘

3.6 증거 화면 (증거.png)
3.6.1 레이아웃
dart┌─────────────────────────────────────┐
│  ← 증거                              │
├─────────────────────────────────────┤
│  ┌──────────┐ ┌──────────┐ ┌─────┐ │
│  │[썸네일]  │ │          │ │     │ │
│  │IMG_현장감│ │          │ │     │ │
│  │식(1).png │ │          │ │     │ │
│  └──────────┘ └──────────┘ └─────┘ │
│                                     │
│  (GridView 3열)                     │
└─────────────────────────────────────┘
3.6.2 증거 카드
dartCard:
  - 썸네일 이미지 (정사각형)
  - 파일명 (하단)
  - 새 증거: 파란 테두리 + "NEW" 뱃지
  - 클릭 → 증거 상세 (확대, 확대/축소 가능)

3.7 AI 질문 패널 (바텀 시트)
3.7.1 레이아웃
dartBottomSheet (하단에서 올라옴):
┌─────────────────────────────────────┐
│         VIT AI 분석 도구             │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💬 질문하기        [-10 토큰]│   │
│  │ 특정 증거에 대해 질문         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🤔 Think          [-50 토큰]│   │
│  │ 현재 증거 종합 분석 (1분)     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🧠 Ultra Think   [-100 토큰]│   │
│  │ 심층 분석 및 레드헤링 (5분)   │   │
│  └─────────────────────────────┘   │
│                                     │
│  현재 토큰: 500                     │
└─────────────────────────────────────┘
3.7.2 AI 응답 화면
dart대화형 UI:
┌─────────────────────────────────────┐
│  ← AI 분석                           │
├─────────────────────────────────────┤
│  👤 당신:                            │
│  "발자국 크기가 의미하는 건?"         │
│                                     │
│  🤖 VIT AI:                         │
│  [타이핑 애니메이션]                 │
│  "발자국 크기 240~245mm는..."        │
│                                     │
│  [분석 중... 1분 소요]  ← Think     │
│  [막대 진행바]                       │
│                                     │
│  📊 결과:                            │
│  - 김수현: 45%                       │
│  - 한지은: 50%                       │
│  - 박준영: 5%                        │
└─────────────────────────────────────┘

4. 게임 시스템 설계
4.1 Day 시스템
dartclass GameDay {
  int currentDay;        // 1-5
  String currentTime;    // "10:15", "14:00" 등
  int tokenBalance;      // 초기 500
  
  List<Email> unreadEmails;
  List<Evidence> newEvidences;
  
  bool canSubmitAnswer; // Day 5만 true
}
4.2 타임라인 진행
Day 1 (월요일):
  10:15 - E01 도착 (사건 배당)
  14:20 - E02 도착 (현장 분석)
  17:40 - E03 도착 (용의자 조사)

Day 2 (화요일):
  10:35 - E04 도착 (부검 결과)
  15:50 - E05 도착 (알리바이 검증)
  18:15 - E06 도착 (약물 추적)

... (Day 5까지)
4.3 토큰 시스템
dartenum AIAction {
  question(cost: 10),    // 즉시
  think(cost: 50),       // 1분 대기
  ultraThink(cost: 100); // 5분 대기
  
  final int cost;
  const AIAction({required this.cost});
}

class TokenManager {
  int balance = 500;
  
  bool canAfford(AIAction action) {
    return balance >= action.cost;
  }
  
  void spend(AIAction action) {
    balance -= action.cost;
    saveToLocal();
  }
}
4.4 보강 수사 시스템
dartclass EnhancedInvestigation {
  String emailId;
  int cost = 20;
  bool isAvailable;
  bool isCompleted;
  
  List<String> additionalFiles; // 다음 날 제공
}

// 예시:
E02 보강 수사 → Day 2에 추가 파일 3개 제공

5. 데이터 모델
5.1 핵심 모델
dart// 이메일 모델
class Email {
  String id;              // "E01", "E02"...
  int day;                // 1-5
  Sender sender;
  String subject;
  String body;
  List<Attachment> attachments;
  bool hasEnhancement;    // 보강 수사 가능 여부
  bool isRead;
  DateTime timestamp;
}

// 증거 모델
class Evidence {
  String id;
  String filename;
  String type;            // "image", "pdf", "document"
  String assetPath;
  int unlockedDay;        // 어느 Day에 해금되는지
  bool isNew;
}

// 용의자 모델
class Suspect {
  String id;              // "kimSuHyun", "hanJiEun", "parkJunYoung"
  String name;
  String nameHanja;
  int age;
  String relationship;
  String occupation;
  String profileImage;
  
  double aiProbability;   // AI 분석 확률 (0-100)
  List<Evidence> relatedEvidences;
  String playerNotes;     // 플레이어 메모
}

// 최종 제출
class FinalSubmission {
  String suspectId;
  String reasoning;       // 플레이어 작성 근거
  DateTime submittedAt;
}
5.2 JSON 데이터 구조
json// assets/data/emails/day1.json
{
  "emails": [
    {
      "id": "E01",
      "day": 1,
      "sender": {
        "name": "박진수 형사",
        "department": "강남서 형사1팀"
      },
      "timestamp": "2025-10-28T10:15:00",
      "subject": "변사사건 배당",
      "body": "프로파일링센터에 새로운...",
      "attachments": [
        {
          "filename": "현장사진_01.jpg",
          "type": "image",
          "assetPath": "assets/images/e01_crime_scene.jpg"
        }
      ],
      "hasEnhancement": false
    }
  ]
}

6. AI 통합 (Claude API)
6.1 API 구조
dartclass ClaudeService {
  // 1. 질문하기 (10토큰)
  Future<String> askQuestion(String question) async {
    // 현재 게임 상태 + 질문을 컨텍스트로 전달
    final context = _buildGameContext();
    
    final response = await claudeAPI.sendMessage(
      messages: [
        {"role": "user", "content": "$context\n\n질문: $question"}
      ]
    );
    
    return response.content;
  }
  
  // 2. Think (50토큰, 1분)
  Future<ThinkResult> performThink() async {
    // 현재까지 모든 증거 분석
    await Future.delayed(Duration(minutes: 1)); // 시뮬레이션
    
    return ThinkResult(
      probabilities: {
        "kimSuHyun": 45,
        "hanJiEun": 50,
        "parkJunYoung": 5
      },
      reasoning: "발자국 크기와 동기를 고려하면..."
    );
  }
  
  // 3. Ultra Think (100토큰, 5분)
  Future<UltraThinkResult> performUltraThink() async {
    await Future.delayed(Duration(minutes: 5));
    
    return UltraThinkResult(
      finalVerdict: "한지은 단독범행",
      confidence: 85,
      redHerrings: ["김수현 검색 기록은 소설 자료"],
      keyEvidence: ["발자국 245mm", "낚시 경험", "500억 동기"]
    );
  }
}
6.2 게임 컨텍스트 구성
dartString _buildGameContext() {
  return """
현재 Day ${gameState.currentDay}
읽은 이메일: ${gameState.readEmails.map((e) => e.id).join(', ')}
발견한 증거: ${gameState.evidences.length}개
  
주요 증거:
- 발자국 크기: 240-245mm
- 디곡신 검출
- 밀실 상황
  
용의자:
1. 김수현 (30세, 비서) - 30억 횡령
2. 박준영 (52세, 부사장) - 100억 횡령, 강한 알리바이
3. 한지은 (43세, 전처) - 500억 상속 동기
  
플레이어 질문: {질문 내용}
""";
}

7. UI/UX 가이드라인
7.1 컬러 팔레트
dartclass GameColors {
  // 다크 테마 (기본)
  static const background = Color(0xFF1a1a1a);      // 검정
  static const surface = Color(0xFF2d2d2d);         // 어두운 회색
  static const primary = Color(0xFF4a9eff);         // 파란색 (강조)
  static const accent = Color(0xFFff6b6b);          // 빨간색 (긴급)
  
  // 텍스트
  static const textPrimary = Color(0xFFffffff);     // 흰색
  static const textSecondary = Color(0xFFb0b0b0);   // 회색
  static const textHint = Color(0xFF6d6d6d);        // 흐린 회색
  
  // 상태
  static const unread = Color(0xFF4a9eff);          // 안 읽음
  static const newItem = Color(0xFF4ade80);         // 새 항목
  static const urgent = Color(0xFFff6b6b);          // 긴급
}
7.2 타이포그래피
dartclass GameTextStyles {
  // 제목
  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: GameColors.textPrimary,
  );
  
  // 본문
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: GameColors.textPrimary,
  );
  
  // 메일 발신자
  static const emailSender = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: GameColors.textPrimary,
  );
  
  // 타임스탬프
  static const timestamp = TextStyle(
    fontSize: 12,
    color: GameColors.textSecondary,
  );
}
7.3 애니메이션
dart// 화면 전환
const transitionDuration = Duration(milliseconds: 300);
const transitionCurve = Curves.easeInOut;

// 새 메일 도착
void animateNewEmail() {
  // 흔들림 + 페이드인
  AnimationController(
    duration: Duration(milliseconds: 500),
    vsync: this,
  )..repeat(reverse: true);
}

// AI 분석 중
void showAnalyzingAnimation() {
  // 로딩 바 + 타이핑 효과
  LinearProgressIndicator(
    backgroundColor: GameColors.surface,
    valueColor: AlwaysStoppedAnimation(GameColors.primary),
  );
}

8. 파일 구조
lib/
├── main.dart
├── app.dart
│
├── models/
│   ├── email.dart
│   ├── evidence.dart
│   ├── suspect.dart
│   ├── game_state.dart
│   └── ai_response.dart
│
├── providers/
│   ├── game_state_provider.dart
│   ├── token_provider.dart
│   └── ai_service_provider.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── main_screen.dart          # 메인 바탕화면
│   ├── case_files_screen.dart    # 사건 파일
│   ├── suspect_detail_screen.dart
│   ├── email_list_screen.dart    # 메일함
│   ├── email_detail_screen.dart
│   ├── evidence_screen.dart      # 증거
│   ├── evidence_detail_screen.dart
│   └── final_submission_screen.dart
│
├── widgets/
│   ├── folder_icon.dart
│   ├── email_card.dart
│   ├── evidence_card.dart
│   ├── ai_panel.dart
│   ├── suspect_card.dart
│   └── day_timer.dart
│
├── services/
│   ├── claude_service.dart       # AI 통합
│   ├── storage_service.dart      # 로컬 저장
│   └── asset_loader.dart         # JSON 로드
│
├── utils/
│   ├── constants.dart
│   ├── colors.dart
│   ├── text_styles.dart
│   └── helpers.dart
│
└── assets/
    ├── data/
    │   ├── emails/
    │   │   ├── day1.json
    │   │   ├── day2.json
    │   │   └── ...
    │   ├── suspects.json
    │   └── game_intro.json
    │
    ├── images/
    │   ├── backgrounds/
    │   ├── profiles/
    │   ├── evidences/
    │   └── ui/
    │
    └── fonts/
        └── NotoSans-*.ttf

9. 핵심 기능 구현 가이드
9.1 메인 화면 (main_screen.dart)
dartclass MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _showMenu(context),
        ),
        title: Consumer<GameStateProvider>(
          builder: (context, gameState, _) {
            return Text('D-${6 - gameState.currentDay} ${gameState.currentTime}');
          },
        ),
        actions: [
          // 토큰 표시
          Padding(
            padding: EdgeInsets.all(16),
            child: Consumer<TokenProvider>(
              builder: (context, tokenProvider, _) {
                return Text('Token: ${tokenProvider.balance}');
              },
            ),
          ),
          // 제출하기 버튼
          Consumer<GameStateProvider>(
            builder: (context, gameState, _) {
              if (gameState.currentDay == 5) {
                return TextButton(
                  onPressed: () => _submitAnswer(context),
                  child: Text('제출하기'),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 배경 이미지
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrounds/detective_silhouette.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // 폴더 아이콘 그리드
          Center(
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              children: [
                FolderIcon(
                  icon: Icons.folder,
                  label: '사건 파일',
                  onTap: () => Navigator.pushNamed(context, '/case-files'),
                ),
                Consumer<GameStateProvider>(
                  builder: (context, gameState, _) {
                    return FolderIcon(
                      icon: Icons.email,
                      label: '메일',
                      badge: gameState.unreadEmailCount,
                      onTap: () => Navigator.pushNamed(context, '/emails'),
                    );
                  },
                ),
                FolderIcon(
                  icon: Icons.camera_alt,
                  label: '증거',
                  onTap: () => Navigator.pushNamed(context, '/evidence'),
                ),
              ],
            ),
          ),
          
          // AI 입력창 (하단 고정)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AIInputPanel(),
          ),
        ],
      ),
    );
  }
}
9.2 AI 패널 (ai_panel.dart)
dartclass AIInputPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'VIT AI 분석으로 사건을 해결하세요',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onTap: () => _showAIPanel(context),
            ),
          ),
          IconButton(
            icon: Icon(Icons.auto_awesome, color: GameColors.primary),
            onPressed: () => _showAIPanel(context),
          ),
        ],
      ),
    );
  }
  
  void _showAIPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AIPanelBottomSheet(),
    );
  }
}

class AIPanelBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('VIT AI 분석 도구', style: GameTextStyles.title),
          SizedBox(height: 24),
          
          // 질문하기
          AIActionButton(
            icon: Icons.chat_bubble_outline,
            title: '질문하기',
            cost: 10,
            description: '특정 증거에 대해 질문',
            onPressed: () => _askQuestion(context),
          ),
          
          // Think
          AIActionButton(
            icon: Icons.psychology,
            title: 'Think',
            cost: 50,
            description: '현재 증거 종합 분석 (1분)',
            onPressed: () => _performThink(context),
          ),
          
          // Ultra Think
          AIActionButton(
            icon: Icons.lightbulb_outline,
            title: 'Ultra Think',
            cost: 100,
            description: '심층 분석 및 레드헤링 (5분)',
            onPressed: () => _performUltraThink(context),
          ),
          
          SizedBox(height: 16),
          Consumer<TokenProvider>(
            builder: (context, tokenProvider, _) {
              return Text('현재 토큰: ${tokenProvider.balance}');
            },
          ),
        ],
      ),
    );
  }
}
9.3 메일 리스트 (email_list_screen.dart)
dartclass EmailListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('메일')),
      body: Consumer<GameStateProvider>(
        builder: (context, gameState, _) {
          return ListView.builder(
            itemCount: gameState.emails.length,
            itemBuilder: (context, index) {
              final email = gameState.emails[index];
              return EmailCard(
                email: email,
                onTap: () {
                  gameState.markAsRead(email.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EmailDetailScreen(email: email),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

10. 세이브/로드 시스템
10.1 저장 구조
dartclass SaveData {
  int currentDay;
  String currentTime;
  int tokenBalance;
  List<String> readEmailIds;
  List<String> unlockedEvidenceIds;
  Map<String, String> suspectNotes;  // {suspectId: notes}
  List<EnhancedInvestigation> completedEnhancements;
  
  Map<String, dynamic> toJson();
  factory SaveData.fromJson(Map<String, dynamic> json);
}

class StorageService {
  final SharedPreferences _prefs;
  
  Future<void> saveGame(SaveData data) async {
    await _prefs.setString('save_data', jsonEncode(data.toJson()));
  }
  
  Future<SaveData?> loadGame() async {
    final jsonStr = _prefs.getString('save_data');
    if (jsonStr == null) return null;
    return SaveData.fromJson(jsonDecode(jsonStr));
  }
}

11. 엔딩 시스템
11.1 제출 화면
dartclass FinalSubmissionScreen extends StatefulWidget {
  @override
  _FinalSubmissionScreenState createState() => _FinalSubmissionScreenState();
}

class _FinalSubmissionScreenState extends State<FinalSubmissionScreen> {
  String? selectedSuspect;
  TextEditingController reasoningController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('최종 제출')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text('범인을 지목하세요', style: GameTextStyles.title),
            SizedBox(height: 24),
            
            // 용의자 선택
            ...suspects.map((suspect) => RadioListTile(
              title: Text(suspect.name),
              value: suspect.id,
              groupValue: selectedSuspect,
              onChanged: (value) {
                setState(() => selectedSuspect = value);
              },
            )),
            
            SizedBox(height: 24),
            
            // 근거 작성
            TextField(
              controller: reasoningController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: '범행 근거를 작성하세요',
                border: OutlineInputBorder(),
              ),
            ),
            
            Spacer(),
            
            ElevatedButton(
              onPressed: selectedSuspect != null ? _submit : null,
              child: Text('제출하기'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _submit() {
    final submission = FinalSubmission(
      suspectId: selectedSuspect!,
      reasoning: reasoningController.text,
      submittedAt: DateTime.now(),
    );
    
    // 엔딩 판정
    final ending = _determineEnding(submission);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => EndingScreen(ending: ending)),
    );
  }
  
  Ending _determineEnding(FinalSubmission submission) {
    // 정답: 한지은 단독
    if (submission.suspectId == 'hanJiEun') {
      return Ending.S; // 정답
    } else if (submission.suspectId == 'kimSuHyun') {
      return Ending.B; // 레드헤링
    } else {
      return Ending.F; // 오답
    }
  }
}

12. 플랫폼별 빌드 설정
12.1 Android
yaml# android/app/build.gradle
android {
    compileSdkVersion 33
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
12.2 iOS
xml<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>밤의 침입자</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
12.3 Steam (Desktop)
yaml# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  desktop_window: ^0.4.0  # 창 크기 제어
  
# Windows/macOS 빌드
flutter build windows
flutter build macos

13. 성능 최적화
13.1 이미지 최적화
yaml# 모든 이미지는 WebP로 변환 (용량 50% 감소)
# 해상도: 1920x1080 (배경), 512x512 (프로필)
13.2 레이지 로딩
dart// 메일은 Day별로 동적 로드
Future<List<Email>> loadEmailsForDay(int day) async {
  final jsonStr = await rootBundle.loadString('assets/data/emails/day$day.json');
  return parseEmails(jsonStr);
}
13.3 메모리 관리
dart// 큰 이미지는 캐싱
CachedNetworkImage(
  imageUrl: evidence.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
);

14. QA 체크리스트
14.1 기능 테스트

 Day 1-5 모든 이메일 정상 도착
 토큰 소비/잔액 정확
 AI 응답 정상 작동 (질문/Think/Ultra Think)
 보강 수사 다음 날 제공
 최종 제출 및 엔딩 분기
 세이브/로드 정상 작동

14.2 UI/UX 테스트

 모든 화면 다크 테마 적용
 폰트 가독성 (한글 Noto Sans)
 터치 영역 충분 (최소 44x44)
 애니메이션 부드러움 (60fps)

14.3 플랫폼 테스트

 Android 8.0+ 정상 작동
 iOS 13+ 정상 작동
 Windows/macOS 데스크톱 빌드


15. 출시 전 최종 점검
15.1 스토어 등록 준비
- 아이콘: 512x512 (안드로이드), 1024x1024 (iOS)
- 스크린샷: 5장 (메인, 메일, 사건파일, AI, 엔딩)
- 설명: 200자 (짧은 설명), 4000자 (상세 설명)
- 연령 등급: 15세 / Teen (폭력적 표현 없음)
15.2 Steam 준비
- 스팀워크스 SDK 연동
- 도전과제 10개 설정
- 트레이딩 카드 (선택)
- 클라우드 세이브

16. 개발 일정 (예상)
Week 1-2: UI 프레임워크 구축
  - 메인 화면, 폴더 시스템
  - 네비게이션 구조
  
Week 3-4: 데이터 시스템
  - JSON 파싱
  - 세이브/로드
  - Day 진행 로직
  
Week 5-6: AI 통합
  - Claude API 연동
  - 질문/Think/Ultra Think
  
Week 7-8: 콘텐츠 통합
  - 모든 이메일/증거 연결
  - 엔딩 시스템
  
Week 9-10: 테스트 및 버그 수정
Week 11-12: 플랫폼별 빌드 및 최적화

17. 추가 개발 고려사항
17.1 접근성
dart// 폰트 크기 조절
Semantics(
  label: '이메일 목록',
  child: EmailList(),
);

// 색맹 모드
ColorFilter.matrix(colorBlindMatrix);
17.2 다국어 지원 (추후)
yamlflutter_localizations:
  sdk: flutter
  
# 한국어(기본) → 영어, 일본어 확장 가능
17.3 DLC 가능성
- 추가 사건 (새로운 5일 케이스)
- 하드 모드 (토큰 300 시작)
- 타임 어택 모드