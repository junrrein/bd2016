SELECT au_lname, au_fname, sum(qty)
from authors a
  inner join titleauthor ta ON a.au_id = ta.au_id
  INNER JOIN titles t ON ta.title_id = t.title_id
  INNER JOIN sales s on t.title_id = s.title_id
where s.ord_date BETWEEN '1/1/1993' and '31/12/1994'
group by au_lname, au_fname
having sum(qty) < 25;

delete from titles
where title_id in (select t.title_id
                    from titles t
                      inner join titleauthor ta on t.title_id = ta.title_id
                    where ta.au_id in (SELECT a.au_id
                                          from authors a
                                            inner join titleauthor ta ON a.au_id = ta.au_id
                                            INNER JOIN titles t ON ta.title_id = t.title_id
                                            INNER JOIN sales s on t.title_id = s.title_id
                                          where s.ord_date BETWEEN '1/1/1993' and '31/12/1994'
                                          group by a.au_id
                                          having sum(qty) < 25));