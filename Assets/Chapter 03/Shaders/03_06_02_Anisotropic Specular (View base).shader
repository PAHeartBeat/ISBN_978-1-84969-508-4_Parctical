Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Anisotropic Specular (View base)" {
	Properties {
		_Color ("Color", Color) = (0.73,0.73,0.73,0.73)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_Gloss ("Glossiness", Range(0.01,1)) = 0.5
		_Shininess ("Shininess", Range(0.01,1)) = 0.5
		_AnsioDir ("Ansiotropic Direction", 2D) = "gray" {}
		_AnsioOffset ("Ansiotropic Offset", float) = -0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf AnsiotropicSpecularVB

		sampler2D _MainTex;
		sampler2D _AnsioDir;
		
		fixed4 _Color;
		
		fixed _Gloss;
		fixed _Shininess;
		fixed _AnsioOffset;
		
		struct SurfaceOutputAnsio{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			
			fixed Alpha;
			fixed Gloss;
			half Specular;

			float3 AnsioDir;
		};
		
		struct Input {
			float2 uv_MainTex;
			float2 uv_AnsioDir;
		};

		inline fixed4 LightingAnsiotropicSpecularVB (SurfaceOutputAnsio s, fixed3 lightDir, half3 viewDir, fixed atten){
			half3 h = normalize (lightDir + viewDir);
			
			fixed NdotL = max(0, dot(lightDir, s.Normal));
			
			fixed NdotHL = NdotL * 0.5 + 0.5;
			
			fixed NdotV = max(0, dot(viewDir, s.Normal));
			
			fixed HdotA_raw = saturate (s.Normal + s.AnsioDir);
			
			
			//fixed HdotA = dot(HdotA_raw, h);
			fixed3 HdotA = h *  HdotA_raw ;
			fixed nh = max(0,dot(s.Normal , h));
			
			
			
			//fixed ansio = max(0, sin(radians( (HdotA + _AnsioOffset) * 180)));
			//fixed ansio = max(0, sin( radians( HdotA) * 180 ));
			
			
			fixed spec = pow(nh, s.Specular * 128.0) * s.Gloss;
			
			fixed4 c;
			c.rgb = ((s.Albedo * NdotL * _LightColor0.rgb) + (spec * _SpecColor * _LightColor0.rgb)) * (atten * 2);
			c.a = s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutputAnsio o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed3 ansio = UnpackNormal(tex2D(_AnsioDir,IN.uv_AnsioDir));
			
			o.AnsioDir = ansio;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Specular = _Shininess;
			o.Gloss = _Gloss;
		}
		ENDCG
	} 
	//FallBack "Diffuse"
}
