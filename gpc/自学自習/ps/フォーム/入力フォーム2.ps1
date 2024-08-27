# �A�Z���u���̓ǂݍ���
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# �G���[���b�Z�[�W�{�b�N�X�̕\��
function Show-Error {
    [System.Windows.Forms.MessageBox]::Show("���͂͋󔒂ɂł��܂���B", "�G���[", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}

# ���̓t�H�[���̍쐬�ƕ\��
function Show-InputForm {
    $form = New-Object Windows.Forms.Form -Property @{
        Text = "���̓t�H�[��"
        Size = New-Object Drawing.Size(800, 300)
        StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
        FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        MaximizeBox = $false
    }

    $label = New-Object Windows.Forms.Label -Property @{
        Text = "�e�L�X�g����͂��Ă�������:"
        AutoSize = $true
        Font = New-Object Drawing.Font("���C���I", 16)
        TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        Dock = [System.Windows.Forms.DockStyle]::Top
        Padding = New-Object Windows.Forms.Padding(0, 20, 0, 20)
    }
    $form.Controls.Add($label)

    $textBox = New-Object Windows.Forms.TextBox -Property @{
        Font = New-Object Drawing.Font("���C���I", 16)
        Size = New-Object Drawing.Size(500, 40)
        Location = New-Object Drawing.Point((($form.ClientSize.Width - 500) / 2), 100)
        Anchor = [System.Windows.Forms.AnchorStyles]::Top
    }
    $form.Controls.Add($textBox)

    $okButton = New-Object Windows.Forms.Button -Property @{
        Text = "OK"
        Font = New-Object Drawing.Font("���C���I", 16)
        Size = New-Object Drawing.Size(150, 50)
        Location = New-Object Drawing.Point((($form.ClientSize.Width / 2) - 200), 200)
        DialogResult = [System.Windows.Forms.DialogResult]::OK
    }
    $okButton.Add_Click({
        if ([string]::IsNullOrWhiteSpace($textBox.Text)) {
            Show-Error
        } else {
            $form.Tag = $textBox.Text
            $form.Close()
        }
    })
    $form.Controls.Add($okButton)

    $cancelButton = New-Object Windows.Forms.Button -Property @{
        Text = "�L�����Z��"
        Font = New-Object Drawing.Font("���C���I", 16)
        Size = New-Object Drawing.Size(150, 50)
        Location = New-Object Drawing.Point((($form.ClientSize.Width / 2) + 50), 200)
        DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    }
    $cancelButton.Add_Click({ $form.Close() })
    $form.Controls.Add($cancelButton)

    $form.AcceptButton = $okButton
    $form.ShowDialog()
    return $form
}

# �m�F�t�H�[���̍쐬�ƕ\��
function Show-ConfirmForm {
    param ([string]$inputText)

    $confirmForm = New-Object Windows.Forms.Form -Property @{
        Text = "���͊m�F"
        Size = New-Object Drawing.Size(800, 300)
        StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
        FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
        MaximizeBox = $false
    }

    $label = New-Object Windows.Forms.Label -Property @{
        Text = "���͓��e: $inputText`n���̓��e�ł�낵���ł����H"
        AutoSize = $true
        Font = New-Object Drawing.Font("���C���I", 16)
        TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
        Dock = [System.Windows.Forms.DockStyle]::Top
        Padding = New-Object Windows.Forms.Padding(0, 20, 0, 20)
    }
    $confirmForm.Controls.Add($label)

    $yesButton = New-Object Windows.Forms.Button -Property @{
        Text = "�͂�"
        Font = New-Object Drawing.Font("���C���I", 16)
        Size = New-Object Drawing.Size(150, 50)
        Location = New-Object Drawing.Point((($confirmForm.ClientSize.Width / 2) - 200), 200)
        DialogResult = [System.Windows.Forms.DialogResult]::Yes
    }
    $yesButton.Add_Click({ $confirmForm.Close() })
    $confirmForm.Controls.Add($yesButton)

    $noButton = New-Object Windows.Forms.Button -Property @{
        Text = "������"
        Font = New-Object Drawing.Font("���C���I", 16)
        Size = New-Object Drawing.Size(150, 50)
        Location = New-Object Drawing.Point((($confirmForm.ClientSize.Width / 2) + 50), 200)
        DialogResult = [System.Windows.Forms.DialogResult]::No
    }
    $noButton.Add_Click({ $confirmForm.Close() })
    $confirmForm.Controls.Add($noButton)

    return $confirmForm.ShowDialog()
}

do {
    # ���̓t�H�[����\�����A���[�U�[�̓��͌��ʂƃt�H�[���I�u�W�F�N�g���擾
    $inputForm = Show-InputForm
    $inputResult = $inputForm.DialogResult

    # ���[�U�[��OK�{�^���������A���e�L�X�g�{�b�N�X�Ƀe�L�X�g�����͂���Ă���ꍇ�̏���
    if ($inputResult -eq [System.Windows.Forms.DialogResult]::OK -and $inputForm.Tag) {
        # �m�F�t�H�[����\�����A���͂��ꂽ�e�L�X�g���m�F���邽�߂̌��ʂ��擾
        $confirmResult = Show-ConfirmForm -inputText $inputForm.Tag

        # ���[�U�[��Yes�{�^�����������ꍇ�̏���
        if ($confirmResult -eq [System.Windows.Forms.DialogResult]::Yes) {
            # ���͂��ꂽ�e�L�X�g���R���\�[���ɕ\�����A���[�v���I��
            Write-Host "���͂��ꂽ�e�L�X�g: $($inputForm.Tag)"
            break
        } else {
            # ���[�U�[��No�{�^�����������ꍇ�A���̓t�H�[���ɖ߂�|���R���\�[���ɕ\��
            Write-Host "���͂��m�F����܂���ł����B���̓t�H�[���ɖ߂�܂��B"
        }
    # ���[�U�[���L�����Z���{�^�����������ꍇ�̏���
    } elseif ($inputResult -eq [System.Windows.Forms.DialogResult]::Cancel) {
        # �L�����Z�����ꂽ�|���R���\�[���ɕ\�����A���[�v���I��
        Write-Host "�L�����Z������܂����B"
        break
    }
} while ($true)  # ��ɐ^�̏����Ń��[�v���p������
