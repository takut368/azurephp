#===========================================
#���ϐ���`
#���[�U�[�v���t�@�C���p�X�ϐ���`
$USERPROFILE_PATH = $env:USERPROFILE
#�V���[�g�J�b�g�z�u�p�X��`
$SHORTCUT_PATH = "C:\work"
#�Ј��ԍ��t�H���_�[�쐬�ꏊ��`
$TARGET_PATH = "C:\temp"

#�V���[�g�J�b�g����`
$SHORTCUT_NAME = "$SHORTCUT_PATH\Test.lnk"

#�y�ύX�s�v�zwsShell�I�u�W�F�N�g��`
$wsShell = New-Object -ComObject WScript.Shell

#===========================================

# Microsoft.VisualBasic�A�Z���u����L����
[void][System.Reflection.Assembly]::Load("Microsoft.VisualBasic, Version=8.0.0.0, Culture=Neutral, PublicKeyToken=b03f5f7f11d50a3a")
Add-Type -AssemblyName System.Windows.Forms

# �Ј��ԍ��̓��́E����
do {
    $CONFIRM = "No"

    # �Ј��ԍ�����
    $INPUTNum = [Microsoft.VisualBasic.Interaction]::InputBox("�Ј��ԍ�4������͂��Ă�������", "�Ј��ԍ�����")

    #���͂��󂩔���
    if([string]::IsNullOrEmpty($INPUTNum)){
        # �Ј��ԍ����͏I�����b�Z�[�W�\��
        $wsShell.popup("�Ј��ԍ������͂���Ȃ��������ߏI�����܂��B",0,"�Ј��ԍ�����")
        break
    }elseif([uint16]::TryParse($INPUTNum,[ref]$null) -eq $true -and $INPUTNum.Length -eq "4"){
        # ���͂����Ј��ԍ������p�����S��������
        # �Ј��ԍ��m�F���b�Z�[�W��`
        $ConfirmMessage = "�Ј��ԍ��� " + $INPUTNum + " �Ő������ł����H"
        # �Ј��ԍ��m�F�|�b�v�A�b�v�\��
        $CONFIRM = [System.Windows.Forms.MessageBox]::Show($ConfirmMessage, "�Ј��ԍ��m�F", "YesNo")
    }else{
        # �Ј��ԍ��ē��̓��b�Z�[�W�\��
        $wsShell.popup("�Ј��ԍ��𔼊p�����S���ōēx���͂��Ă��������B",0,"�Ј��ԍ��m�F")
    }

} while ($CONFIRM -eq "No" ) #�Ј��ԍ��m�F���u�͂��v�ɂȂ�܂ŎЈ��ԍ����͂��J��Ԃ�


if( ([uint16]::TryParse($INPUTNum,[ref]$null) -eq $true) -and
    ($INPUTNum.Length -eq "4") -and
    ($CONFIRM -eq "Yes")){
#�Ј��ԍ��t�H���_�쐬
New-Item -Path "$TARGET_PATH\$INPUTNum" -ItemType Directory -ErrorAction SilentlyContinue
#�Ј��ԍ��t�H���_�̃p�X��ϐ��֊i�[
$EmployeeNumberFolder = "$TARGET_PATH\$INPUTNum"
# �V���[�g�J�b�g�쐬
$Shortcut = $wsShell.CreateShortcut("$SHORTCUT_NAME")
# �V���[�g�J�b�g�̃����N��w��
$Shortcut.TargetPath = "$EmployeeNumberFolder"
# �V���[�g�J�b�g�̃A�C�R���w��
$shortcut.IconLocation = "$EmployeeNumberFolder"
# �V���[�g�J�b�g�ݒ�ۑ�
$Shortcut.Save()
}
