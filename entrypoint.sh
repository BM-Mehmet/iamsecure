#!/bin/bash
set -e

echo "Host Guvenlik Duvari (iptables) Ayarlaniyor..."

# --- 1. ICERI GELEN TRAFIK KURALLARI (YONLENDIRME) ---
# SSH (22) portuna dokunma (Sunucuya baglantimiz kesilmesin)
iptables -t nat -A PREROUTING -p tcp --dport 22 -j RETURN

# WAF portlarina dokunma (80 ve 443'e gelenleri WAF karsilayacak)
iptables -t nat -A PREROUTING -p tcp --dport 80 -j RETURN
iptables -t nat -A PREROUTING -p tcp --dport 443 -j RETURN

# Portspoof'un kendi portuna (4444) dogrudan dokunma
iptables -t nat -A PREROUTING -p tcp --dport 4444 -j RETURN

# Geri kalan TUM gelen TCP trafigini Portspoof'a (4444) yonlendir
iptables -t nat -A PREROUTING -p tcp -j REDIRECT --to-ports 4444

# --- 1.5 YEREL TRAFIK YONLENDIRMESI (Testler Icin) ---
# PREROUTING sadece disaridan gelenleri yakalar. "curl localhost" gibi
# sunucu icinden yapilan testlerin de calismasi icin OUTPUT zincirini ayarliyoruz.
iptables -t nat -A OUTPUT -p tcp --dport 22 -j RETURN
iptables -t nat -A OUTPUT -p tcp --dport 80 -j RETURN
iptables -t nat -A OUTPUT -p tcp --dport 443 -j RETURN
iptables -t nat -A OUTPUT -p tcp --dport 4444 -j RETURN
# Kendi kendine (localhost) atilan istekleri de Portspoof'a yonlendir
iptables -t nat -A OUTPUT -p tcp -d 127.0.0.1 -j REDIRECT --to-ports 4444

# --- 2. DISARI GIDEN TRAFIK KURALLARI (GUVENLIK KAFESI) ---
# 'appuser' (UID 2000) kullanicisinin disariya baglanti baslatmasini ENGELLE.
# Bu, Honeypot hacksense bile saldirganin disari veri kacirmasini veya baska yere saldirmasini onler.
# Ancak mevcut baglantilara cevap verebilmesi icin ESTABLISHED (kurulmus) baglantilara izin veriyoruz.
iptables -A OUTPUT -m owner --uid-owner 2000 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner 2000 -j DROP

echo "Guvenlik Duvari Aktif: Giris Yonlendirmeleri + Cikis Kafesi (UID 2000)."
echo "Portspoof 'appuser' (UID 2000) kullanicisi ile baslatiliyor..."

# Portspoof'u 'appuser' yetkileriyle baslat (Root yetkisini birak)
su appuser -s /bin/bash -c "/usr/local/bin/portspoof -c /etc/portspoof.conf -s /etc/portspoof_signatures"
