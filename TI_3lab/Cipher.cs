namespace timb3
{
    public class Cipher
    {
        
        public static byte[] Encode(byte[] data,int key,int r)
        {
            byte[] result = new byte[data.Length*2];
            for (int i = 0; i < data.Length; i++)
            {
                int k = CipMath.IntPower(data[i],key,r);
                int j = i << 1;
                result[j] = (byte)k;
                result[j+1] = (byte)(k>>8);
            }
            return result;
        }
        
        public static byte[] Decode(byte[] data,int key,int r)
        {
            byte[] res = new byte[data.Length/2];
            for(int i = 0;i < res.Length; i++)
            {
                int j = i << 1;
                int k = CipMath.IntPower((int)(data[j]) + ((int)data[j+1]<<8), key, r);
                res[i] = (byte)k;
            }
            return res;
        }
        
    } 
}
