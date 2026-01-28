# IAMSECURE: Akıllı Güvenlik ve Honeypot Sistemi

IAMSECURE, sunucunuzu hem gerçek saldırılardan koruyan (WAF) hem de saldırganları yanıltarak vakit kaybettiren (Honeypot) hibrit bir güvenlik çözümüdür. 

Bu proje, Docker tabanlı bir mimari kullanarak kolayca kurulabilir ve yönetilebilir.

## 🚀 Özellikler

- **Web Application Firewall (WAF):** OWASP Core Rule Set (CRS) yüklü Nginx ModSecurity ile SQL Injection, XSS ve diğer web saldırılarını engeller.
- **Portspoof Honeypot:** Sunucunuzdaki 65.000 portu açıkmış gibi göstererek saldırganları tarama aşamasında yanıltır ve yavaşlatır.
- **Güvenli Mimari:** Gerçek servisler (`real_server`) dış dünyaya kapalıdır ve sadece WAF üzerinden erişilebilir.
- **Otomatik Kurulum:** Tek bir script ile Docker, Docker Compose ve Portspoof kurulumu yapılır.

## 🏗️ Mimari Yapı

Proje iki ana gruptan oluşur:

1.  **Güvenli Servisler (Clean Traffic):** 
    - `waf`: Kapıdaki güvenlik görevlisi.
    - `real_server`: WAF arkasında korunan asıl içerik.
2.  **Honeypot Sistemi (Dirty Traffic):**
    - `portspoof`: Saldırganları karşılayan tuzak sistem. Tüm port taramalarını manipüle eder.

## 🛠️ Kurulum

Sistemi Ubuntu veya Debian tabanlı bir sunucuya kurmak oldukça basittir:

```bash
# Projeyi klonlayın (Henüz yapmadıysanız)
git clone https://github.com/BM-Mehmet/iamsecure.git
cd iamsecure

# Kurulum scriptini çalıştırın
chmod +x install.sh
sudo ./install.sh
```

`install.sh` scripti şu işlemleri otomatik yapar:
1. Docker ve Docker Compose kurulumunu gerçekleştirir.
2. Portspoof deposunu orijinal kaynağından çeker.
3. Docker konteynerlerini yapılandırıp başlatır.

## 📂 Dosya Yapısı

- `install.sh`: Otomatik kurulum ve başlatma scripti.
- `docker-compose.yml`: Tüm servislerin orkestrasyon dosyası.
- `Dockerfile`: Portspoof için özel Docker imajı oluşturma dosyası.
- `entrypoint.sh`: Portspoof konteyneri için ağ kurallarını (iptables) yöneten betik.
- `waf/`: WAF yapılandırma dosyaları.

## ⚠️ Güvenlik Uyarısı (Disclaimer)

Bu araç eğitim ve güvenlik araştırmaları amacıyla geliştirilmiştir. Kullanırken yerel yasalar ve etik kurallar çerçevesinde hareket ediniz. Sistemdeki `iptables` kuralları ağ trafiğinizi etkileyebilir, bu nedenle üretim ortamında kullanmadan önce test ediniz.

## 📝 Lisans

Bu proje MIT lisansı ile lisanslanmıştır.
