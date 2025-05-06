using System;
using System.Text;

namespace timb3
{
    public class transfer
    {
        public static string BytesToStr(byte[] data)
        {
            StringBuilder sb = new StringBuilder();
            if (data.Length < 100)
                for (int i = 0; i < data.Length; i++)
                    sb.Append(data[i].ToString() + " ");
            else
            {
                for (int i = 0; i < 50; i++)
                    sb.Append(data[i].ToString() + " ");
                sb.Append("\n\n...\n\n");
                for (int i = data.Length - 1; i > data.Length - 50; i--)
                    sb.Append(data[i].ToString() + " ");
            }

            return sb.ToString();
        }
        public static string WordsToStr(byte[] data)
        {
            StringBuilder sb = new StringBuilder();
            if (data.Length < 200)  
                for (int i = 0; i < data.Length - 2; i += 2)
                    sb.Append((data[i] + (data[i + 1] << 8)).ToString() + " ");
            else
            {
                for (int i = 0; i < 100; i += 2)
                    sb.Append((data[i] + (data[i + 1] << 8)).ToString() + " ");
                sb.Append("\n\n...\n\n");
                for (int i = data.Length - 2; i > data.Length - 100; i -= 2)
                    sb.Append((data[i] + (data[i + 1] << 8)).ToString() + " ");
            }

            return sb.ToString();
        }
    }

}