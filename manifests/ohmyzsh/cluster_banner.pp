# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include cluster_tools::ohmyzsh::cluster_banner
class cluster_tools::ohmyzsh::cluster_banner(
  String  $cluster_name,
  String  $project_name,
  String  $user_name,
) {

  file_line { "ensure cluster_banner function exists for ${user_name}":
    ensure => present,
    path   => "/home/$user_name/.p10k.zsh",
    match  => '^  function prompt_cluster_banner',
    line   => "  function prompt_cluster_banner() { p10k segment -f 32 -i '⧉' -t '${project_name}-${cluster_name}' }",
    after  => "# typeset -g POWERLEVEL9K_TIME_PREFIX='%fat '",
  }

  file_line { "ensure cluster_banner function enabled for ${user_name}":
    ensure => present,
    path   => "/home/$user_name/.p10k.zsh",
    match  => "    cluster_banner",
    line   => "    cluster_banner",
    after  => "^    # example user-defined segment",
  }


}
