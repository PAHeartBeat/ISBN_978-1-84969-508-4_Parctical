Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Specular (Phong)" { 

	Properties {
		_Color ("Color", color) = (0.5,0.5,0.5)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range(0.01,60) ) = 0.078125
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300
		
		CGPROGRAM
		#pragma surface surf Phong
		
		sampler2D _MainTex;
		fixed4 _Color;
		fixed _Shininess;
		
		struct Input {
			float2 uv_MainTex;
		};

		// Specular light spot or specular light reflcation is one kind BRDF effect and it's need viewer direction
		// Specular spot(s) are realy on from which direction viewer view the object.
		inline fixed4 LightingPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
		
			// to get SPecular reflation we need to first get diffuse value
			fixed diff = max(0, dot (s.Normal, lightDir));
			
			// Phong specular reflace calculated by dot produt of eye and refraction of light via normal
			// to getting refraction of light via surface / normal direction
			// diff = NdotL which multiply by const value 2 and surface direaction which are letter substract via
			// lightDir
			//
			// formula is r = 2 * N * (NdotL) - L
			// ref:
			// http://ruh.li/GraphicsPhongBlinnPhong.html
			// https://www.siggraph.org/education/materials/HyperGraph/illumin/specular_highlights/phong_model_specular_reflection.htm
			// http://graphics.cs.cmu.edu/nsp/course/15-462/Spring04/slides/07-lighting.pdf
			//
			// there are also some other variants as bellow maintions shaders
			// "Specular (Phong) Net Ref - 1" file named "03_02_02_Specular (Phong) Net Ref - 1.shader"
			//
			// both varient has diffrent output
			fixed3 specRf = normalize(2 * s.Normal * diff - lightDir);
			
			fixed specDir = max(0, dot(specRf, viewDir));
			fixed specInte = pow(max(0, specDir), s.Specular);
			fixed3 finalSpec = specInte * _SpecColor.rgb;
			
			fixed4 c;
			c.rgb = ((s.Albedo * _LightColor0.rgb * diff ) + (finalSpec));
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
			o.Specular = _Shininess;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
