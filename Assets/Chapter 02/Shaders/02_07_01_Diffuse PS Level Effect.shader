Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/02_07_01_Diffuse PS Level Effect" {
	Properties {
		_Color ("Color", Color) = (1, 1, 1, 1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_InWhite ("Input White", Range(0,255)) = 255
		_InGamma ("Input Gamma", float) = 1
		_InBlack ("Input Black", Range(0,255)) = 0
		
		_OutWhite ("Out White", Range(0,255)) = 255
		_OutBlack ("Out Black", Range(0,255)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert
		fixed4 _Color;
		sampler2D _MainTex;

		fixed _InWhite;
		fixed _InGamma;
		fixed _InBlack;
		
		fixed _OutWhite;
		fixed _OutBlack;

		struct Input {
			float2 uv_MainTex;
		};


		fixed OutColor(fixed inColor){
			fixed oColor;
			
			// inColor is 0 to 1, becose its calculated using tex2D with texutre UV and Texure Property
			// Which gives value 0 to 1;
			oColor = inColor * 255;
			
			// Remove in Black Color from current Color Chanel
			oColor = max(0,oColor - _InBlack);
			
			// Incrase white value using steps
			// Step 1. - InWhite and InBlack value
			// Step 2. - Now device current chanel Chanel color value devide by value of Step 1
			// step 3. - Power step 2 value with InGamma Value
			// Step 4. - saturate that paricutlar value from Step 3
			oColor = saturate(pow(oColor / (_InWhite - _InBlack), _InGamma));
			
			// Chnage Colors white point and black point
			oColor = (oColor * (_OutWhite - _OutBlack) + _OutBlack) / 255f;
			
			// Re Map Color value as 0 to 1 (right now its 0 to 255)
			oColor = oColor ;
			
			return oColor;
		}
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			c.r = OutColor(c.r);
			c.g = OutColor(c.g);
			c.b = OutColor(c.b);
			
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
