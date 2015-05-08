Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Specular (Phong) Net Ref - 1" { 

	Properties {
		_Color ("Color", color) = (0.5,0.5,0.5)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range(0.01,1) ) = 0.078125
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300
		
		CGPROGRAM
		#pragma surface surf CustomBlinnPhong
		
		sampler2D _MainTex;
		fixed4 _Color;
		fixed _Shininess;
		
		struct Input {
			float2 uv_MainTex;
		};

	
		inline fixed4 LightingCustomBlinnPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
			fixed diff = max(0, dot (s.Normal, lightDir));
			
			// Phong specular reflace calculated by dot produt of eye and reflaction of light via normal
			// to getting reflaction of light via surface / normal direction
			// diff = NdotL which multiply by const value 2 and surface direaction which are letter substract via
			// lightDir
			//
			// formula is r = 2 * N * (NdotL) - L
			// ref: http://ruh.li/GraphicsPhongBlinnPhong.html
			// actual phong specular shader is not this one. actual Phong Spacular shader name given next line
			// "Specular (Phong)" file namde "03_02_01_Specular (Phong).shader"
			//
			// but this shader is another varieant of the orignal calculation
			// this method not depend on refraction vector of light direction and surface direction
			// this method based on halfway fof light direction and view direction and calcualte by
			// nomalization of L + V like 
			// vector H = normalize( vector L + vector V)
			// this methtod also known as "Blinn-Phong method",
			// ref:
			// http://www.cs.utexas.edu/~bajaj/graphics2012/cs354/lectures/lect14.pdf
			// http://www.robots.ox.ac.uk/~att/index.html
			//
			// both varient has diffrent output
			fixed3 halfDir = normalize(lightDir + viewDir);
			
			fixed nh = max(0, dot(s.Normal, halfDir));
			fixed spec = pow(nh, _Shininess * 128) * s.Gloss;
			
			fixed4 c;
			c.rgb = ((s.Albedo * _LightColor0.rgb * diff ) + (spec * _SpecColor.rgb * _LightColor0.rgb)) * (atten);
			c.a = s.Alpha;
			return c;
		}
		
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a  * _Color.a;
			
			// For Specular shader we need to assing Specular value which are also know as Specular Power or specular hardness
			// We also need to assign Gloss value normly its came for texture's Alpha Chanel, this property
			// will decide on  intencity of specular on surface area
			
			// Here we customize that value to fix 1 so it will calculate with same intencity on whole surface.
			o.Gloss = c.a;
			o.Specular =  _Shininess;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
