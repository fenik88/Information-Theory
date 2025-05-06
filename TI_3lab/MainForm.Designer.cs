namespace timb3
{
    partial class MainForm
    {
        /// <summary>
        /// Обязательная переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Требуемый метод для поддержки конструктора — не изменяйте 
        /// содержимое этого метода с помощью редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            this.numP = new System.Windows.Forms.NumericUpDown();
            this.numQ = new System.Windows.Forms.NumericUpDown();
            this.numD = new System.Windows.Forms.NumericUpDown();
            this.txtE = new System.Windows.Forms.TextBox();
            this.btnCalculate = new System.Windows.Forms.Button();
            this.btnOpenEncrypt = new System.Windows.Forms.Button();
            this.btnOpenDecrypt = new System.Windows.Forms.Button();
            this.txtIn = new System.Windows.Forms.TextBox();
            this.txtOut = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.lbl = new System.Windows.Forms.Label();
            this.lblR = new System.Windows.Forms.Label();
            this.lblFR = new System.Windows.Forms.Label();
            this.lblRValue = new System.Windows.Forms.Label();
            this.lblFValue = new System.Windows.Forms.Label();
            this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.btnSaveEn = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.numP)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numQ)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numD)).BeginInit();
            this.SuspendLayout();
            // 
            // numP
            // 
            this.numP.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.numP.Location = new System.Drawing.Point(565, 119);
            this.numP.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.numP.Maximum = new decimal(new int[] {
            65535,
            0,
            0,
            0});
            this.numP.Minimum = new decimal(new int[] {
            2,
            0,
            0,
            0});
            this.numP.Name = "numP";
            this.numP.Size = new System.Drawing.Size(112, 20);
            this.numP.TabIndex = 0;
            this.numP.Value = new decimal(new int[] {
            2,
            0,
            0,
            0});
            // 
            // numQ
            // 
            this.numQ.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.numQ.Location = new System.Drawing.Point(565, 154);
            this.numQ.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.numQ.Maximum = new decimal(new int[] {
            65535,
            0,
            0,
            0});
            this.numQ.Minimum = new decimal(new int[] {
            2,
            0,
            0,
            0});
            this.numQ.Name = "numQ";
            this.numQ.Size = new System.Drawing.Size(112, 20);
            this.numQ.TabIndex = 1;
            this.numQ.Value = new decimal(new int[] {
            2,
            0,
            0,
            0});
            // 
            // numD
            // 
            this.numD.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.numD.Location = new System.Drawing.Point(565, 184);
            this.numD.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.numD.Maximum = new decimal(new int[] {
            65535,
            0,
            0,
            0});
            this.numD.Minimum = new decimal(new int[] {
            2,
            0,
            0,
            0});
            this.numD.Name = "numD";
            this.numD.Size = new System.Drawing.Size(112, 20);
            this.numD.TabIndex = 2;
            this.numD.Value = new decimal(new int[] {
            2,
            0,
            0,
            0});
            // 
            // txtE
            // 
            this.txtE.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.txtE.Enabled = false;
            this.txtE.Location = new System.Drawing.Point(565, 249);
            this.txtE.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.txtE.Name = "txtE";
            this.txtE.ReadOnly = true;
            this.txtE.Size = new System.Drawing.Size(113, 20);
            this.txtE.TabIndex = 3;
            // 
            // btnCalculate
            // 
            this.btnCalculate.BackColor = System.Drawing.SystemColors.Info;
            this.btnCalculate.Font = new System.Drawing.Font("Dutch801 XBd BT", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnCalculate.Location = new System.Drawing.Point(565, 216);
            this.btnCalculate.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.btnCalculate.Name = "btnCalculate";
            this.btnCalculate.Size = new System.Drawing.Size(112, 25);
            this.btnCalculate.TabIndex = 5;
            this.btnCalculate.Text = "Вычислить";
            this.btnCalculate.UseVisualStyleBackColor = false;
            this.btnCalculate.Click += new System.EventHandler(this.btnCalculate_Click);
            // 
            // btnOpenEncrypt
            // 
            this.btnOpenEncrypt.BackColor = System.Drawing.SystemColors.Info;
            this.btnOpenEncrypt.Font = new System.Drawing.Font("Dutch801 XBd BT", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnOpenEncrypt.Location = new System.Drawing.Point(231, 11);
            this.btnOpenEncrypt.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.btnOpenEncrypt.Name = "btnOpenEncrypt";
            this.btnOpenEncrypt.Size = new System.Drawing.Size(194, 37);
            this.btnOpenEncrypt.TabIndex = 6;
            this.btnOpenEncrypt.Text = "Шифрование";
            this.btnOpenEncrypt.UseVisualStyleBackColor = false;
            this.btnOpenEncrypt.Click += new System.EventHandler(this.btnOpenEncrypt_Click);
            // 
            // btnOpenDecrypt
            // 
            this.btnOpenDecrypt.BackColor = System.Drawing.SystemColors.Info;
            this.btnOpenDecrypt.Font = new System.Drawing.Font("Dutch801 XBd BT", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnOpenDecrypt.Location = new System.Drawing.Point(482, 11);
            this.btnOpenDecrypt.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.btnOpenDecrypt.Name = "btnOpenDecrypt";
            this.btnOpenDecrypt.Size = new System.Drawing.Size(196, 40);
            this.btnOpenDecrypt.TabIndex = 7;
            this.btnOpenDecrypt.Text = "Дешифрование";
            this.btnOpenDecrypt.UseVisualStyleBackColor = false;
            this.btnOpenDecrypt.Click += new System.EventHandler(this.btnOpenDecrypt_Click);
            // 
            // txtIn
            // 
            this.txtIn.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.txtIn.Location = new System.Drawing.Point(10, 112);
            this.txtIn.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.txtIn.Multiline = true;
            this.txtIn.Name = "txtIn";
            this.txtIn.ReadOnly = true;
            this.txtIn.Size = new System.Drawing.Size(416, 173);
            this.txtIn.TabIndex = 8;
            this.txtIn.TextChanged += new System.EventHandler(this.txtIn_TextChanged);
            // 
            // txtOut
            // 
            this.txtOut.BackColor = System.Drawing.SystemColors.ButtonHighlight;
            this.txtOut.Location = new System.Drawing.Point(10, 344);
            this.txtOut.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.txtOut.Multiline = true;
            this.txtOut.Name = "txtOut";
            this.txtOut.ReadOnly = true;
            this.txtOut.Size = new System.Drawing.Size(416, 177);
            this.txtOut.TabIndex = 9;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.label1.Location = new System.Drawing.Point(544, 122);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(14, 13);
            this.label1.TabIndex = 10;
            this.label1.Text = "P";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.label2.Location = new System.Drawing.Point(544, 158);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(15, 13);
            this.label2.TabIndex = 11;
            this.label2.Text = "Q";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.label3.Location = new System.Drawing.Point(544, 188);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(15, 13);
            this.label3.TabIndex = 12;
            this.label3.Text = "D";
            // 
            // lbl
            // 
            this.lbl.AutoSize = true;
            this.lbl.ForeColor = System.Drawing.SystemColors.ButtonHighlight;
            this.lbl.Location = new System.Drawing.Point(544, 252);
            this.lbl.Name = "lbl";
            this.lbl.Size = new System.Drawing.Size(14, 13);
            this.lbl.TabIndex = 13;
            this.lbl.Text = "E";
            // 
            // lblR
            // 
            this.lblR.AutoSize = true;
            this.lblR.BackColor = System.Drawing.Color.Cyan;
            this.lblR.Location = new System.Drawing.Point(766, 24);
            this.lblR.Name = "lblR";
            this.lblR.Size = new System.Drawing.Size(21, 13);
            this.lblR.TabIndex = 18;
            this.lblR.Text = "R=";
            // 
            // lblFR
            // 
            this.lblFR.AutoSize = true;
            this.lblFR.BackColor = System.Drawing.Color.Cyan;
            this.lblFR.Location = new System.Drawing.Point(875, 24);
            this.lblFR.Name = "lblFR";
            this.lblFR.Size = new System.Drawing.Size(33, 13);
            this.lblFR.TabIndex = 19;
            this.lblFR.Text = "F(R)=";
            // 
            // lblRValue
            // 
            this.lblRValue.AutoSize = true;
            this.lblRValue.BackColor = System.Drawing.Color.Cyan;
            this.lblRValue.Location = new System.Drawing.Point(782, 24);
            this.lblRValue.Name = "lblRValue";
            this.lblRValue.Size = new System.Drawing.Size(13, 13);
            this.lblRValue.TabIndex = 21;
            this.lblRValue.Text = "0";
            // 
            // lblFValue
            // 
            this.lblFValue.AutoSize = true;
            this.lblFValue.BackColor = System.Drawing.Color.Cyan;
            this.lblFValue.Location = new System.Drawing.Point(908, 24);
            this.lblFValue.Name = "lblFValue";
            this.lblFValue.Size = new System.Drawing.Size(13, 13);
            this.lblFValue.TabIndex = 22;
            this.lblFValue.Text = "0";
            // 
            // openFileDialog
            // 
            this.openFileDialog.FileName = "openFileDialog1";
            // 
            // btnSaveEn
            // 
            this.btnSaveEn.BackColor = System.Drawing.SystemColors.Info;
            this.btnSaveEn.Font = new System.Drawing.Font("Dutch801 XBd BT", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSaveEn.Location = new System.Drawing.Point(769, 169);
            this.btnSaveEn.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.btnSaveEn.Name = "btnSaveEn";
            this.btnSaveEn.Size = new System.Drawing.Size(158, 42);
            this.btnSaveEn.TabIndex = 23;
            this.btnSaveEn.Text = "Сохранить";
            this.btnSaveEn.UseVisualStyleBackColor = false;
            this.btnSaveEn.Click += new System.EventHandler(this.btnSaveEn_Click);
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Dutch801 XBd BT", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(20, 82);
            this.label4.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(198, 29);
            this.label4.TabIndex = 24;
            this.label4.Text = "Исходный текст";
            this.label4.Click += new System.EventHandler(this.label4_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Dutch801 XBd BT", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(20, 315);
            this.label5.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(132, 29);
            this.label5.TabIndex = 25;
            this.label5.Text = "Результат";
            this.label5.Click += new System.EventHandler(this.label5_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.DarkGray;
            this.ClientSize = new System.Drawing.Size(954, 559);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.btnSaveEn);
            this.Controls.Add(this.lblFValue);
            this.Controls.Add(this.lblRValue);
            this.Controls.Add(this.lblFR);
            this.Controls.Add(this.lblR);
            this.Controls.Add(this.lbl);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtOut);
            this.Controls.Add(this.txtIn);
            this.Controls.Add(this.btnOpenDecrypt);
            this.Controls.Add(this.btnOpenEncrypt);
            this.Controls.Add(this.btnCalculate);
            this.Controls.Add(this.txtE);
            this.Controls.Add(this.numD);
            this.Controls.Add(this.numQ);
            this.Controls.Add(this.numP);
            this.Margin = new System.Windows.Forms.Padding(3, 4, 3, 4);
            this.Name = "MainForm";
            this.Text = "Шифратор";
            this.Load += new System.EventHandler(this.MainForm_Load);
            ((System.ComponentModel.ISupportInitialize)(this.numP)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numQ)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numD)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.NumericUpDown numP;
        private System.Windows.Forms.NumericUpDown numQ;
        private System.Windows.Forms.NumericUpDown numD;
        private System.Windows.Forms.TextBox txtE;
        private System.Windows.Forms.Button btnCalculate;
        private System.Windows.Forms.Button btnOpenEncrypt;
        private System.Windows.Forms.Button btnOpenDecrypt;
        private System.Windows.Forms.TextBox txtIn;
        private System.Windows.Forms.TextBox txtOut;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label lbl;
        private System.Windows.Forms.Label lblR;
        private System.Windows.Forms.Label lblFR;
        private System.Windows.Forms.Label lblRValue;
        private System.Windows.Forms.Label lblFValue;
        private System.Windows.Forms.OpenFileDialog openFileDialog;
        private System.Windows.Forms.SaveFileDialog saveFileDialog;
        private System.Windows.Forms.Button btnSaveEn;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label5;
    }
}

