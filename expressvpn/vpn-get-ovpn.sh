#m4nual
echo "This provider does not permit downloading ovpn files in an automatic way."
#Note: You can download automatically all .ovpn files previous login as you can view below (use your own cookie and CODE):
#for i in {70..75}; do wget -qO- --load-cookies cookies.txt 'https://www.expressvpn.com/custom_installer?cluster_id=$i&code=CODE&os=linux&source=web&ovpn_use_username_auth=1' > $i.ovpn; done
#find . -size 0 -delete
