#===========================================
#���ϐ���`
#���ϐ��p�X��`
#$ENV_PATH = $env:USERPROFILE #���ϐ�����'��'����������������u$env:�v�̂��ƂɋL�ڂ��邱�ƂŎw��\
#���[�U�[�v���t�@�C���p�X�ϐ���`
$USERPROFILE_PATH = $env:USERPROFILE
#�V���[�g�J�b�g�z�u�p�X��`
$SHORTCUT_PATH = "$USERPROFILE_PATH\desktop"

#�Ј��ԍ��t�H���_�[�ꏊ��`
$TARGET_PATH = "C:\temp"

#�y�ύX�s�v�zwsShell�I�u�W�F�N�g��`
$wsShell = New-Object -ComObject WScript.Shell

#�y�ύX�s�v�z�^�[�Q�b�g�p�X�m�F��`
$TargetCheckResult = Test-Path $TARGET_PATH
#===========================================

Add-Type -AssemblyName System.Windows.Forms

do {
    # �t�H�[���̍쐬
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "�Ј��ԍ�����"
    $form.Width = 300
    $form.Height = 150

    $label = New-Object System.Windows.Forms.Label
    $label.Text = "�Ј��ԍ�4������͂��Ă�������:"
    $label.Top = 20
    $label.Left = 10
    $label.Width = 280

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Top = 50
    $textBox.Left = 10
    $textBox.Width = 260

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Width = 80
    $okButton.Height = 30
    $okButton.Top = 80
    $okButton.Left = 30
    $okButton.Add_Click({
        $inputNum = $textBox.Text
        if ([uint16]::TryParse($inputNum, [ref]$null) -and $inputNum.Length -eq 4) {
            # �m�F���b�Z�[�W
            $confirmMessage = "�Ј��ԍ��� $inputNum �Ő������ł����H"
            $confirmResult = [System.Windows.Forms.MessageBox]::Show($confirmMessage, "�Ј��ԍ��m�F", [System.Windows.Forms.MessageBoxButtons]::YesNo)
            if ($confirmResult -eq [System.Windows.Forms.DialogResult]::Yes) {
                $employeeFolder = "$TARGET_PATH\$inputNum"
                if (Test-Path $employeeFolder) {
                    # �t�H���_�����݂���ꍇ�A�V���[�g�J�b�g���쐬
                    $global:EmployeeNumber = $inputNum
                    $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
                    $form.Close()
                } else {
                    # �t�H���_�����݂��Ȃ��ꍇ�A�G���[���b�Z�[�W��\�����čē��͂𑣂�
                    [System.Windows.Forms.MessageBox]::Show("�Ј��ԍ��t�H���_�����݂��܂���B�ēx���͂��Ă��������B", "�G���[", [System.Windows.Forms.MessageBoxButtons]::OK)
                }
            } else {
                # No�Ȃ�t�H�[�����ĕ\��
                $form.DialogResult = [System.Windows.Forms.DialogResult]::Retry
                $form.Close()
            }
        } else {
            # ���͂��s���Ȃ�G���[���b�Z�[�W
            [System.Windows.Forms.MessageBox]::Show("�Ј��ԍ��𔼊p����4���ōēx���͂��Ă��������B", "���̓G���[")
        }
    })

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "�L�����Z��"
    $cancelButton.Width = 80
    $cancelButton.Height = 30
    $cancelButton.Top = 80
    $cancelButton.Left = 140
    $cancelButton.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    })

    $form.Controls.Add($label)
    $form.Controls.Add($textBox)
    $form.Controls.Add($okButton)
    $form.Controls.Add($cancelButton)

    # �t�H�[���̕\��
    $result = $form.ShowDialog()

} while ($result -eq [System.Windows.Forms.DialogResult]::Retry)

# �t�H�[�����ʂɊ�Â�����
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $inputNum = $global:EmployeeNumber
    $employeeNumberFolder = "$TARGET_PATH\$inputNum"
    $shortcutPath = [System.IO.Path]::Combine($SHORTCUT_PATH, "$inputNum.lnk")
    # �V���[�g�J�b�g�쐬
    $shortcut = $wsShell.CreateShortcut($shortcutPath)
    # �V���[�g�J�b�g�̃����N��w��
    $shortcut.TargetPath = "$employeeNumberFolder"
    # �V���[�g�J�b�g�̃A�C�R���w��
    $shortcut.IconLocation = "$employeeNumberFolder"
    # �V���[�g�J�b�g�ݒ�ۑ�
    $shortcut.Save()
} else {
    Write-Host "�������L�����Z������܂����B"
}
