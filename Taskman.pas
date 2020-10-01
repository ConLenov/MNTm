unit Taskman;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, jpeg, ExtCtrls, StdCtrls, Taskman2, TeEngine, TeeProcs,
   tlhelp32, Grids, registry, WinSvc, uSMBIOS;

type
TProcessTimer = record
    PID: Cardinal;
    KernelTime: FILETIME;
    UserTime: FILETIME;
    Time: Cardinal;
  end;
  TProcessTimersArray = array of TProcessTimer;

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    Image1: TImage;
    Label1: TLabel;
    Timer1: TTimer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    cpu: TImage;
    cpuname: TLabel;
    memory: TImage;
    memoryname: TLabel;
    disk0: TImage;
    disk0name: TLabel;
    internet: TImage;
    internetname: TLabel;
    memoryall: TLabel;
    megabite: TLabel;
    s2: TLabel;
    memoryload: TLabel;
    cpuspeed: TLabel;
    infoframe: TPanel;
    infocpu: TPanel;
    infomemory: TPanel;
    infodisk: TPanel;
    infointernet: TPanel;
    lvProcesses: TListView;
    tmrRefresh: TTimer;
    ListBox1: TListBox;
    Timer2: TTimer;
    N23: TMenuItem;
    procedure N5Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure infocpuDblClick(Sender: TObject);
    procedure infomemoryDblClick(Sender: TObject);
    procedure tmrRefreshTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    ProcessTimersCount: Integer;
    ProcessTimers: TProcessTimersArray;
    function GetSystemInformation: Boolean;
    function GetProcessCPUUsage(const PID: Cardinal; KernelTime,
      UserTime: FILETIME): Byte;
  public
    { Public declarations }
    procedure CurrentInfo;
    procedure MemInfo;
    procedure GetProcessorInfo;
  end;

var
  Form1: TForm1;

implementation

uses Cmd, Unit4, Unit5;

const
  SystemBasicInformation = 0;
  SystemPerformanceInformation = 2;
  SystemTimeOfDayInformation = 3;
  SystemProcessesAndThreadsInformation = 5;

  STATUS_INFO_LENGTH_MISMATCH = $C0000004;

  SERVICE_KERNEL_DRIVER       = $00000001;
   SERVICE_FILE_SYSTEM_DRIVER  = $00000002;
   SERVICE_ADAPTER             = $00000004;
   SERVICE_RECOGNIZER_DRIVER   = $00000008;

   SERVICE_DRIVER              =
     (SERVICE_KERNEL_DRIVER or
      SERVICE_FILE_SYSTEM_DRIVER or
      SERVICE_RECOGNIZER_DRIVER);

   SERVICE_WIN32_OWN_PROCESS   = $00000010;
   SERVICE_WIN32_SHARE_PROCESS = $00000020;
   SERVICE_WIN32               =
     (SERVICE_WIN32_OWN_PROCESS or
      SERVICE_WIN32_SHARE_PROCESS);

   SERVICE_INTERACTIVE_PROCESS = $00000100;

   SERVICE_TYPE_ALL            =
     (SERVICE_WIN32 or
      SERVICE_ADAPTER or
      SERVICE_DRIVER  or
      SERVICE_INTERACTIVE_PROCESS);

type
  PSYSTEM_BASIC_INFORMATION = ^SYSTEM_BASIC_INFORMATION;
  SYSTEM_BASIC_INFORMATION = packed record
    AlwaysZero              : ULONG;
    uKeMaximumIncrement     : ULONG;
    uPageSize               : ULONG;
    uMmNumberOfPhysicalPages: ULONG;
    uMmLowestPhysicalPage   : ULONG;
    uMmHighestPhysicalPage  : ULONG;
    uAllocationGranularity  : ULONG;
    pLowestUserAddress      : POINTER;
    pMmHighestUserAddress   : POINTER;
    uKeActiveProcessors     : POINTER;
    bKeNumberProcessors     : BYTE;
    Filler                  : array [0..2] of BYTE;
  end;

  PSYSTEM_PERFORMANCE_INFORMATION = ^SYSTEM_PERFORMANCE_INFORMATION;
  SYSTEM_PERFORMANCE_INFORMATION = packed record
    nIdleTime               : INT64;
    dwSpare                 : array [0..75]of DWORD;
  end;

  PSYSTEM_TIME_INFORMATION = ^SYSTEM_TIME_INFORMATION;
  SYSTEM_TIME_INFORMATION = packed record
    nKeBootTime             : INT64;
    nKeSystemTime           : INT64;
    nExpTimeZoneBias        : INT64;
    uCurrentTimeZoneId      : ULONG;
    dwReserved              : DWORD;
  end;

  PSYSTEM_THREADS = ^SYSTEM_THREADS;
  SYSTEM_THREADS  = packed record
    KernelTime: LARGE_INTEGER;
    UserTime: LARGE_INTEGER;
    CreateTime: LARGE_INTEGER;
    WaitTime: ULONG;
    StartAddress: Pointer;
    UniqueProcess: DWORD;
    UniqueThread: DWORD;
    Priority: Integer;
    BasePriority: Integer;
    ContextSwitchCount: ULONG;
    State: Longint;
    WaitReason: Longint;
  end;

  PSYSTEM_PROCESS_INFORMATION = ^SYSTEM_PROCESS_INFORMATION;
  SYSTEM_PROCESS_INFORMATION = packed record
    NextOffset: ULONG;
    ThreadCount: ULONG;
    Reserved1: array [0..5] of ULONG;
    CreateTime: FILETIME;
    UserTime: FILETIME;
    KernelTime: FILETIME;
    ModuleNameLength: WORD;
    ModuleNameMaxLength: WORD;
    ModuleName: PWideChar;
    BasePriority: ULONG;
    ProcessID: ULONG;
    InheritedFromUniqueProcessID: ULONG;
    HandleCount: ULONG;
    Reserved2 : array[0..1] of ULONG;
    PeakVirtualSize : ULONG;
    VirtualSize : ULONG;
    PageFaultCount : ULONG;
    PeakWorkingSetSize : ULONG;
    WorkingSetSize : ULONG;
    QuotaPeakPagedPoolUsage : ULONG;
    QuotaPagedPoolUsage : ULONG;
    QuotaPeakNonPagedPoolUsage : ULONG;
    QuotaNonPagedPoolUsage : ULONG;
    PageFileUsage : ULONG;
    PeakPageFileUsage : ULONG;
    PrivatePageCount : ULONG;
    ReadOperationCount : LARGE_INTEGER;
    WriteOperationCount : LARGE_INTEGER;
    OtherOperationCount : LARGE_INTEGER;
    ReadTransferCount : LARGE_INTEGER;
    WriteTransferCount : LARGE_INTEGER;
    OtherTransferCount : LARGE_INTEGER;
    ThreadInfo: array [0..0] of SYSTEM_THREADS;
  end;

  function NtQuerySystemInformation(
    SystemInformationClass: DWORD;
    SystemInformation : Pointer;
    SystemInformationLength : DWORD;
    var ReturnLength: DWORD
    ): DWORD; stdcall; external 'ntdll.dll';

{$R *.dfm}

function TForm1.GetSystemInformation: Boolean;
type
  PTokenUser = ^TTokenUser;
  TTokenUser = record
    user: array [0..0] of TSIDAndAttributes;
  end;

  TProcessInfo = record
    UserName: String;
    SessionID: Integer;
    USERObjCount: Integer;
    GDIObjCount: Integer;
  end;

  function GetProcessInfo(const ProcessHandle: Cardinal): TProcessInfo;
  const
    TokenSessionId: TTokenInformationClass = TTokenInformationClass(12);
  var
    TokenHandle: THandle;
    ReturnLength: DWORD;
    TknUser: PTokenUser;
    userName : array [0..255] of char;
    userNameLen : DWORD;
    domainName : array [0..255] of char;
    domainNameLen : DWORD;
    use : SID_NAME_USE;
  begin
    Result.UserName := 'UNKNOWN';
    Result.SessionID := -1;
    Result.USERObjCount := GetGuiResources(ProcessHandle, GR_USEROBJECTS);
    Result.GDIObjCount := GetGuiResources(ProcessHandle, GR_GDIOBJECTS);

    if OpenProcessToken(ProcessHandle, TOKEN_QUERY, TokenHandle) then
    try
      
      GetTokenInformation(TokenHandle, TokenSessionId, @Result.SessionID,
        SizeOf(Result.SessionID), ReturnLength);


      GetTokenInformation(TokenHandle, TokenUser, nil, 0, ReturnLength);
      if GetLastError = ERROR_INSUFFICIENT_BUFFER then
      begin
        TknUser := GetMemory(ReturnLength);
        if TknUser <> nil then
        try
          if GetTokenInformation(TokenHandle, TokenUser,
            TknUser, ReturnLength, ReturnLength) then
          begin
            SetLength(Result.UserName, 255);
            userNameLen := 255;
            domainNameLen := 255;
            if LookupAccountSid(nil, TknUser^.User[0].Sid,
              userName, userNameLen, domainName, domainNameLen, use) then
              Result.UserName := String(userName);
          end;
        finally
          FreeMemory(TknUser);
        end;
      end;
    finally
      CloseHandle(TokenHandle);
    end;
  end;

var
  SystemInformation, Temp: PSYSTEM_PROCESS_INFORMATION;
  ReturnLength: DWORD;
  ProcessInfo: TProcessInfo;
  hProcess: THandle;
  AKernelTime: TSystemTime;
begin
  Result := False;
  // ?????? ????? ??????????? ??????
  lvProcesses.Items.BeginUpdate;
  try
    lvProcesses.Items.Clear;
    ReturnLength := 0;
    if NtQuerySystemInformation(
      SystemProcessesAndThreadsInformation,
      nil, 0, ReturnLength) <> STATUS_INFO_LENGTH_MISMATCH then Exit;
    if ReturnLength > 0 then
    begin
      GetMem(SystemInformation, ReturnLength);
      try
        if NtQuerySystemInformation(SystemProcessesAndThreadsInformation,
          SystemInformation, ReturnLength, ReturnLength) = 0 then
        begin
          Temp := SystemInformation;
          repeat
            with lvProcesses.Items.Add do
            begin
              if Temp^.ModuleName = nil then
                Caption := 'System Idle Process'
              else
                Caption := Temp^.ModuleName;
              SubItems.Add(IntToStr(Temp^.ProcessID));

              hProcess := OpenProcess(PROCESS_QUERY_INFORMATION, True, Temp^.ProcessID);
              if hProcess <> 0 then
              try
                ProcessInfo := GetProcessInfo(hProcess);
                SubItems.Add(ProcessInfo.UserName);
                SubItems.Add(IntToStr(ProcessInfo.SessionID));
              finally
                CloseHandle(hProcess);
              end
              else
              begin
                SubItems.Add('СИСТЕМА');
              end;


              SubItems.Add(IntToStr(GetProcessCPUUsage(Temp^.ProcessID,
                Temp^.KernelTime, Temp^.UserTime)));
              SubItems.Add(IntToStr(Temp^.WorkingSetSize div 1024) + ' K');
            end;
            Temp := Pointer(DWORD(Temp) + Temp^.NextOffset);
          until Temp^.NextOffset = 0;
        end;
      finally
        FreeMem(SystemInformation);
      end;
    end;
  finally
    lvProcesses.Items.EndUpdate;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GetSystemInformation;
  ProcessTimersCount := 0;
end;

var
  nOldIdleTime    : Int64 = 0;
  nOldSystemTime  : INT64 = 0;
  nNewCPUTime     : ULONG = 0;

  procedure TForm1.GetProcessorInfo;
  Var
    SMBios : TSMBios;
    LProcessorInfo : TProcessorInformation;
    LSRAMTypes : TCacheSRAMTypes;
    I : Integer;
  begin
    SMBios := TSMBios.Create;
    try
      if SMBios.HasProcessorInfo
      then
        for I := Low(SMBios.ProcessorInfo) to High(SMBios.ProcessorInfo) do
        begin
          LProcessorInfo := SMBios.ProcessorInfo[I];
          cpuspeed.Caption:= Format('%d  Mhz', [LProcessorInfo.RAWProcessorInformation^.CurrentSpeed]);
           end
    finally
      SMBios.Free;
    end;
  end;

procedure TForm1.tmrRefreshTimer(Sender: TObject);
var
  spi : SYSTEM_PERFORMANCE_INFORMATION;
  sti : SYSTEM_TIME_INFORMATION;
  sbi : SYSTEM_BASIC_INFORMATION;
  Dummy: DWORD;
begin
GetProcessorInfo;
CurrentInfo;
  GetSystemInformation;
  if NTQuerySystemInformation(SystemBasicInformation, @sbi,
    SizeOf(SYSTEM_BASIC_INFORMATION), Dummy) = NO_ERROR then
    if NTQuerySystemInformation(SystemTimeOfDayInformation, @sti,
      SizeOf(SYSTEM_TIME_INFORMATION), Dummy) = NO_ERROR then
      if NTQuerySystemInformation(SystemPerformanceInformation, @spi,
        SizeOf(SYSTEM_PERFORMANCE_INFORMATION), Dummy) = NO_ERROR then
      begin
        if (nOldIdleTime <> 0) then
        begin
          nNewCPUTime:= Trunc(100 - ((spi.nIdleTime - nOldIdleTime)
            / (sti.nKeSystemTime - nOldSystemTime) * 100)
            / sbi.bKeNumberProcessors + 0.5);
        end;
        nOldIdleTime   := spi.nIdleTime;
        nOldSystemTime := sti.nKeSystemTime;
      end;
end;

function TForm1.GetProcessCPUUsage(const PID: Cardinal; KernelTime,
  UserTime: FILETIME): Byte;
var
  I: Integer;
  AKernelTime, AUserTime, BKernelTime, BUserTime: TSystemTime;
  Time: Cardinal;
  Tmp: DWORD;
begin
  Result := 0;
  if ProcessTimersCount > 0 then
    for I := 0 to ProcessTimersCount - 1 do
      if ProcessTimers[I].PID = PID then
      begin
        FileTimeToSystemTime(KernelTime, AKernelTime);
        FileTimeToSystemTime(UserTime, AUserTime);
        FileTimeToSystemTime(ProcessTimers[I].KernelTime, BKernelTime);
        FileTimeToSystemTime(ProcessTimers[I].UserTime, BUserTime);

        Time := GetTickCount;
        Tmp :=
          (((AKernelTime.wSecond - BKernelTime.wSecond) * 1000) +
           (AKernelTime.wMilliseconds - BKernelTime.wMilliseconds) +
           ((AUserTime.wSecond - BUserTime.wSecond) * 1000) +
           (AUserTime.wMilliseconds - BUserTime.wMilliseconds));
        Result := 100 * Tmp div (Time - ProcessTimers[I].Time);

        while Result > 100 do Dec(Result, 100);

        ProcessTimers[I].KernelTime := KernelTime;
        ProcessTimers[I].UserTime := UserTime;
        ProcessTimers[I].Time := Time;
        Exit;
      end;
  Inc(ProcessTimersCount);
  SetLength(ProcessTimers, ProcessTimersCount);
  ProcessTimers[ProcessTimersCount - 1].PID := PID;
  ProcessTimers[ProcessTimersCount - 1].KernelTime := KernelTime;
  ProcessTimers[ProcessTimersCount - 1].UserTime := UserTime;
  ProcessTimers[ProcessTimersCount - 1].Time := GetTickCount;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
 Form1.Close;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
 Form2.Show;
 Form1.Hide;
end;

procedure TForm1.MemInfo;
var memstat:tmemorystatus;
begin
MemStat.dwLength := SizeOf(MemStat);
GlobalMemoryStatus(MemStat);
with MemStat do begin
  memoryall.Caption := Format('%0.3f ',[dwTotalPhys div 1024 / 1024]);
  memoryload.Caption :=Format('%0.3f ',[(dwTotalPhys-dwAvailPhys) div 1024 /1024]);
end;
end;

procedure TForm1.CurrentInfo;
begin
meminfo;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
 if (timer1.Enabled=true) and (timer1.interval=100) then N17.Checked:=true else N17.checked:=false;
if (timer1.Enabled=true) and (timer1.interval=1000) then N18.Checked:=true else N18.checked:=false;
if (timer1.enabled=true) and (timer1.interval=10000) then N19.Checked:=true else N19.Checked:=false;
if timer1.enabled=false then N20.Checked:=true else N20.Checked:=false;
end;

procedure TForm1.N17Click(Sender: TObject);
begin
timer1.Enabled:=true;
timer1.Interval:=100;
tmrRefresh.Enabled:=true;
tmrRefresh.Interval:=100;
timer2.Enabled:=true;
timer2.Interval:=100;
end;

procedure TForm1.N18Click(Sender: TObject);
begin
timer1.Enabled:=true;
timer1.Interval:=1000;
tmrRefresh.Enabled:=true;
tmrRefresh.Interval:=1000;
timer2.Enabled:=true;
timer2.Interval:=1000;
end;

procedure TForm1.N19Click(Sender: TObject);
begin
timer1.Enabled:=true;
timer1.Interval:=10000;
tmrRefresh.Enabled:=true;
tmrRefresh.Interval:=10000;
timer2.Enabled:=true;
timer2.Interval:=10000;
end;

procedure TForm1.N20Click(Sender: TObject);
begin
timer1.Enabled:=false;
tmrRefresh.Enabled:=false;
timer2.Enabled:=false;
end;

procedure TForm1.N6Click(Sender: TObject);
begin
 if N6.checked=true then
 begin
  N6.Checked:=false;
  Form1.FormStyle:=fsNormal;
 end
else
 begin
  N6.Checked:=true;
  Form1.FormStyle:=fsStayOnTop;
 end;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
newtask.Show;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
CurrentInfo;
GetProcessorInfo;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
CurrentInfo;
GetProcessorInfo;
end;

procedure TForm1.infocpuDblClick(Sender: TObject);
begin
cpuform.Show;
 Form1.Hide;
end;

procedure TForm1.infomemoryDblClick(Sender: TObject);
begin
 memform.Show;
 Form1.Hide;
end;

function ServiceGetList(
   sMachine : string;
   dwServiceType,
   dwServiceState : DWord;
   slServicesList : TStrings )
   : boolean;
 const
   { Количество служб не более 4096
    Уменьшить при необходимости }
   cnMaxServices = 4096;

 type
   TSvcA = array[0..cnMaxServices]
           of TEnumServiceStatus;
   PSvcA = ^TSvcA;

 var
   //
   // временная переменная
   j : integer;

   //
   // управление службами
   schm          : SC_Handle;

   //
   // байт нужно для буфера
   nBytesNeeded,

   //
   // количество служб
   nServices,

   //
   // указатель на следующую службу
   nResumeHandle : DWord;

   //
   // состояние службы
   ssa : PSvcA;
 begin
   Result := false;

   // подключаемся к управлению службами
   schm := OpenSCManager(
     PChar(sMachine),
     Nil,
     SC_MANAGER_ALL_ACCESS);

   // если удачно
   if(schm > 0)then
   begin
     nResumeHandle := 0;

     New(ssa);

     EnumServicesStatus(
       schm,
       dwServiceType,
       dwServiceState,
       ssa^[0],
       SizeOf(ssa^),
       nBytesNeeded,
       nServices,
       nResumeHandle );

     //
     // Предположим, что размер массива достаточен

     for j := 0 to nServices-1 do
     begin
       slServicesList.
         Add( StrPas(
           ssa^[j].lpDisplayName ) );
     end;

     Result := true;

     Dispose(ssa);

     // закрыть дескриптор управления службами
     CloseServiceHandle(schm);
   end;
 end;

 

procedure TForm1.Timer2Timer(Sender: TObject);
begin
ServiceGetList( '',
    SERVICE_WIN32,
    SERVICE_STATE_ALL,
    ListBox1.Items );
end;

end.
