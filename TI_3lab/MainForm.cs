
using System;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace timb3
{
    public partial class MainForm : Form
    {
        private byte[] decryptedData;
        private byte[] encryptedData;
        private bool isDecryptionMode = false;
        private bool showingEncryptedData = false;
        public MainForm()
        {
            InitializeComponent();
        }
        private void btnCalculate_Click(object sender, EventArgs ee)
        {
            int p = (int)numP.Value, q = (int)numQ.Value, d = (int)numD.Value;
            StringBuilder sb = new StringBuilder();
            if (!CipMath.IsPrime(p))
                sb.Append("P должно быть простым числом" + "\n");
            if (!CipMath.IsPrime(q))
                sb.Append("Q должно быть простым числом" + "\n");
            int r = p * q;
            if (r <256)
                sb.Append("P*Q должно быть больше 256" +"\n");
            else if (r > 256*256-1)
                sb.Append("P*Q должно быть меньше 65.535" + "\n");

            if (sb.Length == 0)
            {
                lblRValue.Text = r.ToString();
                int fe = CipMath.FEuler(p, q);
                lblFValue.Text = fe.ToString();
                if (d >= fe)
                    sb.Append("D должно быть меньше F(R)" + "\n");
                else
                {
                    int[] f = CipMath.GetInverse(fe, d);
                    if (f[2] != 1)
                        sb.Append("D и F(R) должны иметь НОД = 1" + "\n");
                    else
                        txtE.Text = f[1].ToString();
                }
            }
            else
            {
                lblRValue.Text = "";
                lblFValue.Text = "";
            }

            if (sb.Length != 0)
                MessageBox.Show(sb.ToString());
        }


        private void btnSaveEn_Click(object sender, EventArgs e)
        {
            if (saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                try
                {
                    byte[] dataToSave = txtOut.Text.Contains("Зашифрованные данные")
                        ? encryptedData
                        : decryptedData;

                    if (dataToSave != null)
                    {
                        File.WriteAllBytes(saveFileDialog.FileName, dataToSave);
                        MessageBox.Show("Файл успешно сохранен!", "Успех",
                                      MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Ошибка сохранения: {ex.Message}", "Ошибка",
                                  MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
            }
        }

        private void btnOpenEncrypt_Click(object sender, EventArgs e)
        {
            showingEncryptedData = true;
            isDecryptionMode = false;
            int r = (int)numP.Value * (int)numQ.Value;
            if ((r > 256) && (r < 65535) && openFileDialog.ShowDialog() == DialogResult.OK)
            {
                decryptedData = File.ReadAllBytes(openFileDialog.FileName);
                txtIn.Text = "Исходный текст:\n" + transfer.BytesToStr(decryptedData);

                encryptedData = Cipher.Encode(decryptedData, int.Parse(txtE.Text), r);
                txtOut.Text = "Зашифрованные данные:\n" + transfer.WordsToStr(encryptedData);
            }
        }

        private void btnOpenDecrypt_Click(object sender, EventArgs e)
        {
            showingEncryptedData = false;
            isDecryptionMode = true;
            int r = (int)numP.Value * (int)numQ.Value;
            if ((r > 256) && (r < 65535) && openFileDialog.ShowDialog() == DialogResult.OK)
            {
                encryptedData = File.ReadAllBytes(openFileDialog.FileName);
                txtIn.Text = "Зашифрованные данные:\n" + transfer.WordsToStr(encryptedData);

                decryptedData = Cipher.Decode(encryptedData, (int)numD.Value, r);
                txtOut.Text = "Результат дешифрования:\n" + transfer.BytesToStr(decryptedData);
            }
        }


        private void btnClear_Click(object sender, EventArgs e)
        {
            txtIn.Clear();
            txtOut.Clear();
            decryptedData = null;
            encryptedData = null;
        }

        private void txtIn_TextChanged(object sender, EventArgs e)
        {

        }

        private void MainForm_Load(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }
    }
}

