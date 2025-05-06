using System;

namespace timb3
{
    public class CipMath
    {
        public static int IntPower(int x,int k,int n)
        {
            int x1 = x;
            int k1 = k;
            int y = 1;
            while (k1 > 0)
            {
                while ((k1 & 1) == 0)
                {
                    k1 /= 2;
                    x1 = (x1*x1) % n;
                }
                k1--;
                y = (y*x1) % n;
            }
            return y;
        }
        public static bool IsPrime(int v)
        {
            if (v == 4)
                return false;    
            bool res = true;
            for (int i = 2; i < Math.Sqrt(v); i++)
                if (v % i==0)
                {
                    res = false;
                    break;
                }
            return res;
        }
        public static int FEuler(int i, int j) => ((i-1)*(j-1));
        public static int[] GetInverse(int a,int b)
        {
            int x0 = 1, x1 = 0, y0 = 0, y1 = 1, d0 = a, d1 = b;
            while (d1 > 1)
            {
                int q = d0 / d1;
                int d2 = d0 % d1;
                int x2 = x0 - q*x1;
                int y2 = y0 - q*y1;
                d0 = d1;
                d1 = d2;
                x0 = x1; 
                x1 = x2;
                y0 = y1;
                y1 = y2;
            }
            if (y1 < 0)
                y1 += a;
            return new int[]{x1,y1,d1 };
        }
    }
}
