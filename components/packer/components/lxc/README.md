# Packer LXC builder

Este componente usa o **Packer LXC** (classic) para construir imagens de container como tarball (rootfs.tar.gz).

## LXC vs LXD

| | LXC (classic) | LXD |
|---|---------------|-----|
| **Binários** | `lxc-create`, `lxc-start`, `lxc-destroy` | cliente `lxc` (launch, list, …) |
| **Packer** | Plugin **hashicorp/lxc** (este componente) | Plugin hashicorp/lxd (outro builder) |
| **Onde roda** | Diretamente no Linux | Pode ter servidor remoto |

O `brew install lxc` no macOS instala o **cliente LXD**, que fala com um servidor LXD (ex.: na VM). O builder do Packer que estamos usando exige **LXC clássico** (pacote `lxc` no Linux), que não existe no macOS.

Por isso o build precisa rodar **dentro de um Linux** que tenha LXC clássico instalado (por exemplo uma VM Multipass/Ubuntu).

## Opção 1: Rodar o build dentro da VM (recomendado)

1. **Preparar a VM** com LXC clássico (na VM Ubuntu):

   ```bash
   # Na VM ou via multipass exec
   sudo apt-get update
   sudo apt-get install -y lxc
   ```

   Ou use o script do projeto (a partir da raiz do repo):

   ```bash
   ./scripts/packer-lxc-prepare-vm.sh
   ```

2. **Montar o repositório na VM** (no macOS):

   ```bash
   multipass mount $(pwd) lxd:the-lab-zone-iac
   ```

3. **Dentro da VM**: instalar Atmos (e Packer) e rodar o build no diretório montado:

   ```bash
   multipass shell lxd
   cd the-lab-zone-iac
   # Instalar Atmos + Packer uma vez (ex.: via brew no Linux ou binários)
   atmos packer build lxc -s caddy-packer
   ```

Se você já tiver Atmos e Packer (com plugin LXC) instalados na VM, o passo 3 é só `cd the-lab-zone-iac && atmos packer build lxc -s caddy-packer`.

## Opção 2: Usar o builder LXD (outro fluxo)

Se quiser usar só LXD (sem LXC clássico), é preciso trocar para o plugin **Packer LXD** e outro template (imagem LXD em vez de rootfs tar.gz). Isso muda o artefato e o fluxo; não está coberto por este README.

## Config

- **config/lxc.conf** (na raiz do repo): config do container LXC (rede veth + lxcbr0). O builder usa `${path.root}/config/lxc.conf`, então o build deve ser executado a partir da raiz do repositório (ou de um diretório onde exista `config/lxc.conf`).
