# frozen_string_literal: true

# Create class scrapper
class Scrapper
  def initialize(url)
    @url = url
    @page = "Nokogiri.HTML(URI.open(#{@url}))"
  end

  # Récupération du nom des mairies dans un array
  def get_townhall_name(link)
    list = []
    link.xpath('//a[@class="lientxt"]').map { |i| list << i.text }
    puts ''
    puts '-- Liste des noms mairies : OK'
    puts ''
    list
  end

  # Récupération de la portion de lien figurant dans le href des noms de mairies
  def townhall_url(link)
    list = []
    link.xpath('//a[@class="lientxt"]/@href').map { |i| list << i.text }
    puts '-- Récupération des liens des mairies : OK'
    puts ''
    list
  end

  # Création des liens puis récupération des adresses mails des mairies sous forme d'un array.
  def get_townhall_email(townhall_url)
    final_url = []
    townhall_url.each do |i|
      final_url << "https://www.annuaire-des-mairies.com/#{i}"
    end
    puts '-- Liens des mairies reconstitués : OK', ''
    puts '-- Veuillez patienter le temps du chargement ... '

    list_mails = []
    final_url.each do |i|
      list_mails << Nokogiri.HTML(URI.open(i)).xpath('//td[2][contains(text(),"@")]').text
    end
    puts '-- Récupération des adresses mails des mairies : OK', ''
    list_mails
  end

  # Assemblage des arrays (noms des mairies, adresses mails)
  # puis conversion en hash et ajout dans un array
  def combine_all(name, email)
    final_array = []
    full_array = name.zip(email)
    full_array.each { |k| final_array << [k].to_h }
    final_array
  end

  def to_json(link)
    File.open('../db/email.json', 'a') do |f|
      f.write(link.to_json)
    end
  end

  def save_as_csv(link)
    File.open('../db/emails.csv', 'w') do |csv|
      link.each do |i|
        csv << [i.keys.first, i.values.first]
      end
    end
  end

  def perform(link)
    link = @page
    name = get_townhall_name(link)
    email = get_townhall_email(townhall_url(link))
    townhall_url(link)
    result = combine_all(name, email)
    to_json(result)
    save_as_csv(result)
    puts ''
    puts '-- Génération de votre document terminée !!!'

    puts 'Voulez-vous voir le document ? (O / N)'
    choice = gets.chomp.upcase.to_s

    if choice == 'O'
      puts result
    elsif choice == 'N'
      false
    else
      puts 'Vous devez taper O ou N'
    end
  end
end

# perform(Page)
